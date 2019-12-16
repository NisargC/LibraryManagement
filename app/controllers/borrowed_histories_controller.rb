class BorrowedHistoriesController < ApplicationController
  before_action :set_borrowed_history, only: [:show, :edit, :update, :destroy]

  # GET /borrowed_histories
  # GET /borrowed_histories.json
  def index
    if session[:role] == 'admin'
      @borrowed_histories = BorrowedHistory.all
    elsif session[:role] == 'student'
      @borrowed_histories = BorrowedHistory.where(user_id: session[:user_id], returned_on: [nil, ''])
    else
      @borrowed_histories = BorrowedHistory.where(returned_on: [nil, ''], book_id: Book.where(library_id: Librarian.where(user_id: session[:user_id]).pluck(:library_id)))
    end
  end

  # GET /borrowed_histories/1
  # GET /borrowed_histories/1.json
  def show
  end

  # GET /borrowed_histories/new
  def new
    @borrowed_history = BorrowedHistory.new
  end

  # GET /borrowed_histories/1/edit
  def edit
  end

  # POST /borrowed_histories
  # POST /borrowed_histories.json
  def create
    singleBook = Book.where(isbn: borrowed_history_params[:isbn], checked_out: 0).limit(1)
    checkedout_books_count = BorrowedHistory.where(returned_on: nil, user_id: borrowed_history_params[:user_id], isbn: borrowed_history_params[:isbn]).size
    if(checkedout_books_count>0)
      respond_to do |format|
          format.html { redirect_to books_path, notice: 'You have already checked out this book, cannot allow transaction!' }
          format.json { render :show, status: :created, location: books_path }
      end
    elsif task_params[:task] == 'checkout' && singleBook.size == 1 && BorrowedHistory.where(user_id: borrowed_history_params[:user_id], isbn: borrowed_history_params[:isbn], returned_on: nil).size == 0
      if singleBook[0][:special_collection] == TRUE
        request = Request.new(requests_params)
        respond_to do |format|
          if request.save
            format.html { redirect_to books_path, notice: 'Request generated for approval.' }
            format.json { render :show, status: :created, location: books_path }
          else
            format.html { redirect_to books_path, notice: 'Error Occurred while generating approval request' }
            format.json { render json: @borrowed_history.errors, status: :unprocessable_entity }
          end
        end
      else
        borrowed_history_params[:book_id] = singleBook[0][:book_id]
        borrowed_history_params[:title] = singleBook[0][:title]
        @borrowed_history = BorrowedHistory.new(borrowed_history_params)
        student = Student.where(user_id: borrowed_history_params[:user_id])[0]
        student.update(borrow_count: student[:borrow_count]+1)
        singleBook.update(checked_out: 1)
        studentUser = User.where(id:student[:user_id]).limit(1)[0]
        CheckoutDoneMailer.checkout_done(studentUser, student, singleBook[0]).deliver_now
        respond_to do |format|
          if @borrowed_history.save

            format.html { redirect_to books_path, notice: 'Book was successfully checked out.' }
            format.json { render :show, status: :created, location: books_path }
          else
            format.html { redirect_to books_path, notice: 'Some Error Occurred' }
            format.json { render json: @borrowed_history.errors, status: :unprocessable_entity }
          end
        end
      end
    elsif HoldRequest.where(user_id: borrowed_history_params[:user_id], isbn: borrowed_history_params[:isbn]).size == 0 && BorrowedHistory.where(user_id: borrowed_history_params[:user_id], isbn: borrowed_history_params[:isbn], returned_on: nil).size == 0
      respond_to do |format|
        if HoldRequest.new(isbn: borrowed_history_params[:isbn], user_id: borrowed_history_params[:user_id]).save
          format.html { redirect_to books_path, notice: 'Book was enqueued in Hold requests.' }
          format.json { render :show, status: :created, location: books_path }
        else
          format.html { redirect_to books_path, notice: 'Some Error Occurred' }
          format.json { render json: @borrowed_history.errors, status: :unprocessable_entity }
        end
      end
    else
      flash[:notice] = 'Book already checked out or in hold requests.'
      redirect_back(fallback_location: books_path)
    end
  end

  # PATCH/PUT /borrowed_histories/1
  # PATCH/PUT /borrowed_histories/1.json
  def update
    respond_to do |format|
      if @borrowed_history.update(borrowed_history_params)
        format.html { redirect_to @borrowed_history, notice: 'Borrowed history was successfully updated.' }
        format.json { render :show, status: :ok, location: @borrowed_history }
      else
        format.html { render :edit }
        format.json { render json: @borrowed_history.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_borrowed_history
    @borrowed_history = BorrowedHistory.find(params[:id])
  end

    # Never trust parameters from the scary internet, only allow the white list through.

  def task_params
    params.permit(:task)
  end

  def count_params
    params.permit(:count)
  end

  def borrowed_history_params
    params.permit(:user_id, :isbn, :borrowed_on, :due_on, :book_id, :title)
  end

  def requests_params
    params[:status] = 0
    params.permit(:user_id, :isbn, :status)
  end
end
