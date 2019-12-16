class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  # GET /books
  # GET /books.json
  def index
    if search_params[:author].nil?
      if session[:role] == 'student'
        @books = Book.where(library_id: Library.where(university: Student.where(user_id: session[:user_id]).pluck(:university)).pluck(:id)).uniq(&:isbn)
      elsif session[:role] == 'librarian'
        @books = Book.where(library_id: Library.where(id: Librarian.where(user_id: session[:user_id]).pluck(:library_id)).pluck(:id)).uniq(&:isbn)
      else
        @books = Book.all.uniq(&:isbn)
      end
    else
      params[:published_date] = params[:book][:published_date]
      title = search_params[:title]
      author = search_params[:author]
      subject = search_params[:subject]
      published_date = search_params[:published_date]
      if session[:role] == 'student'
        @books = Book.where(library_id: Library.where(university: Student.where(user_id: session[:user_id]).pluck(:university)).pluck(:id)).where("books.title LIKE '%#{title}%' and books.author LIKE '%#{author}%' and books.subject LIKE '%#{subject}%' and books.published_date LIKE '%#{published_date}%'").uniq(&:isbn)
      elsif session[:role] == 'librarian'
        @books = Book.where(library_id: Library.where(id: Librarian.where(user_id: session[:user_id]).pluck(:library_id)).pluck(:id)).where("books.title LIKE '%#{title}%' and books.author LIKE '%#{author}%' and books.subject LIKE '%#{subject}%' and books.published_date LIKE '%#{published_date}%'").uniq(&:isbn)
      else
        @books = Book.where("books.title LIKE '%#{title}%' and books.author LIKE '%#{author}%' and books.subject LIKE '%#{subject}%' and books.published_date LIKE '%#{published_date}%'").uniq(&:isbn)
      end
   end

  end

  # GET /books/1
  # GET /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    count = params[:count].to_i
    success_flag = TRUE
    book_params_copy = book_params
    while count != 0
      @book = Book.new(book_params_copy)

      success_flag = if @book.save
                       TRUE
                     else
                       FALSE
                     end
      count -= 1
    end
    respond_to do |format|
      if success_flag == TRUE
        format.html { redirect_to books_url, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    special_collection = FALSE
    special_collection = TRUE if Book.where(isbn: @book[:isbn]).pluck(:special_collection)[0].to_s == 'true'
    if book_params[:special_collection] == 'true'
      update_book_database
    elsif special_collection.to_s != book_params[:special_collection]
      params[:request] = params[:id]
      params[:approvals] = '1'
      approvals
    else
      update_book_database
    end
  end

  def update_book_database
    books = Book.where(isbn: @book[:isbn])
    success_flag = TRUE
    book_params_copy = book_params
    books.each do |book|
      success_flag = if book.update(book_params_copy)
                       TRUE
                     else
                       FALSE
                     end
    end
    respond_to do |format|
      if success_flag == TRUE
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    deref_book = Book.where(id: @book[:id]).where(checked_out: FALSE).first
    if !deref_book.nil?
      deref_book.destroy
      respond_to do |format|
        format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to books_url, notice: 'All books of this ISBN are checked out. Cannot delete checked out books' }
        format.json { head :no_content }
      end
    end
  end

  def approvals
    params[:isbn] = @book[:isbn].to_i
    # Special Collection Book request
    request = Request.where(user_id: params[:request], status: 0, isbn: params[:isbn])
    user = Student.where(user_id: params[:request]).first
    if user[:borrow_count] < user[:max_books]
      handle_book(user, request, Book.where(isbn: params[:isbn], checked_out: FALSE).first)
    else
      flash[:alert] = 'Generating Hold Request for the user who requested as max count reached.'
      hold_request
      respond_to do |format|
        if request.update(status: 2)
          format.html { redirect_to @book, notice: 'Pending request has been approved as this book no longer needs librarian approval for checkout.' }
          format.json { render :index, status: :ok, location: @book }
        else
          format.html { redirect_to @book, notice: 'Some Error Occurred' }
          format.json { render json: @book.errors, status: :unprocessable_entity }
        end
      end
    end
    update_book_database
  end

  def hold_request
    if HoldRequest.new(isbn: params[:isbn], user_id: params[:request]).save
      flash[:alert] += ' Hold request generated successfully'
    else
      flash[:alert] += ' Some error occurred while generating Hold request'
    end
  end

  def approve_deny_request(request, status)
    respond_to do |format|
      if request.update(status: status)
        req_status = if status == 1
                       'approved'
                     else
                       'rejected'
                     end
        flash[:notice] = 'Request has been successfully ' + req_status
        format.html { redirect_to @book }
        format.json { render :index, status: :ok, location: @book }
        return 1
      else
        format.html { render :@book }
        format.json { render json: @book.errors, status: :unprocessable_entity }
        return 0
      end
    end
  end

  def handle_book(user, request, single_book)
    if !single_book.blank? && approve_deny_request(request, 1) == 1
      borrowed_history = BorrowedHistory.new(borrowed_history_params(single_book))
      single_book.update(checked_out: 1)
      user.update(borrow_count: user[:borrow_count] + 1)
      student_user = User.where(id: user[:user_id]).limit(1)[0]
      if borrowed_history.save
        CheckoutDoneMailer.checkout_special(student_user, user, single_book).deliver_now
        flash[:alert] = 'Book was automatically allotted to users in the waiting list.'
      else
        flash[:alert] = 'Error occurred while allotting book to user.'
      end
    else
      flash[:alert] = ' Request has been approved but the book is already checked out, hence,'
      approve_deny_request(request, 1)
      hold_request
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_book

    @book = Book.find(params[:id])

  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def search_params
    # params[:published_date] = params[:books][:published_date]
    params.permit(:title, :author, :published_date, :subject, :id)
  end

  def borrowed_history_params(single_book)
    params[:book_id] = single_book[:id]
    params[:borrowed_on] = Date.today
    params[:due_on] = Date.today + Library.where(id: single_book[:library_id])[0].max_days
    params[:user_id] = params[:request]
    params[:title] = single_book[:title]
    params.permit(:user_id, :isbn, :book_id, :borrowed_on, :due_on, :title)
  end

  def book_params

    if params[:book].nil?
      params
    elsif !params[:book][:front_cover].nil?
      params[:book][:front_cover] = open(params.fetch(:book)[:front_cover].open()){|f| Base64.strict_encode64(f.read)}
      params.fetch(:book).permit(:isbn, :title, :author, :language, :published_date, :subject, :front_cover, :library_id, :edition, :special_collection, :summary)
    else
      params.fetch(:book).permit(:isbn, :title, :author, :language, :published_date, :subject, :front_cover, :library_id, :edition, :special_collection, :summary)
    end
  end

end
