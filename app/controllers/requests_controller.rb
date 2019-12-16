class RequestsController < ApplicationController
  before_action :set_request, only: [:show, :edit, :update, :destroy]

  # GET /requests
  # GET /requests.json
  def index
    if User.where(id: session[:user_id]).pluck(:role).equal?(1)
    else
      @librarian_request = Request.where(isbn: [nil, ''], status: 0)
    end
    @book_request = Request.where.not(isbn: [nil, ''], status: [1, 2])
  end

  # GET /requests/1
  # GET /requests/1.json
  def show
  end

  # GET /requests/new
  def new
    @request = Request.new
  end

  # GET /requests/1/edit
  def edit
  end

  # POST /requests
  # POST /requests.json
  def create
    @request = Request.new(request_params)

    respond_to do |format|
      if @request.save
        format.html { redirect_to @request, notice: 'Request was successfully created.' }
        format.json { render :show, status: :created, location: @request }
      else
        format.html { render :new }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /requests/1
  # PATCH/PUT /requests/1.json
  def update
    respond_to do |format|
      if @request.update(request_params)
        format.html { redirect_to @request, notice: 'Request was successfully updated.' }
        format.json { render :show, status: :ok, location: @request }
      else
        format.html { render :edit }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /requests/approvals
  def approvals
    params[:isbn] = params[:isbn].to_i
    if params[:isbn].to_i != 0
      # Special Collection Book request
      request = Request.where(user_id: params[:request], status: 0, isbn: params[:isbn])
    else
      # Librarian Approval request
      request = Request.where(user_id: params[:request], isbn: nil, status: 0)
    end
    if params[:approval] == '1'
      if params[:isbn].to_i != 0
        user = Student.where(user_id: params[:request]).first
        if user[:borrow_count] < user[:max_books]
          handle_book(user, request, Book.where(isbn: params[:isbn], checked_out: FALSE).first)
        else
          flash[:alert] = 'Generating Hold Request for the user as max count reached.'
          hold_request
          respond_to do |format|
            if request.update(status: 2)
              format.html { redirect_to requests_url, notice: 'Request has been approved' }
              format.json { render :index, status: :ok, location: @request }
            else
              format.html { redirect_to requests_url, notice: 'Some Error Occurred' }
              format.json { render json: @request.errors, status: :unprocessable_entity }
            end
          end
        end
      else
        approve_deny_request(request, 1)
      end
    else
      approve_deny_request(request, 2)
    end
    redirect_to requests_path
  end

  def handle_book(user, request, single_book)
    if !single_book.blank? && approve_deny_request(request, 1) == 1
      borrowed_history = BorrowedHistory.new(borrowed_history_params(single_book))
      single_book.update(checked_out: 1)
      user.update(borrow_count: user[:borrow_count] + 1)
      studentUser = User.where(id: user[:user_id]).limit(1)[0]
      if borrowed_history.save
      CheckoutDoneMailer.checkout_special(studentUser, user, single_book).deliver_now
      flash[:alert] = 'Book was successfully given to the user.'
      else
        flash[:alert] = 'Error occurred while allotting book to user.'
      end
    else
      flash[:alert] = ' Request has been approved but the book is already checked out, hence,'
      approve_deny_request(request, 1)
      hold_request
    end
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
        format.html { redirect_to requests_url }
        format.json { render :index, status: :ok, location: @request }
        return 1
      else
        format.html { render :edit }
        format.json { render json: @request.errors, status: :unprocessable_entity }
        return 0
      end
    end
  end

  def destroy
    @request.destroy
    respond_to do |format|
      format.html { redirect_to student_requests_path, notice: 'Special collection book request successfully deleted!' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_request
    @request = Request.find(params[:id])
  end

    # Never trust parameters from the scary internet, only allow the white list through.
  def request_params
    params.fetch(:request, {})
  end

  def borrowed_history_params(single_book)
    params[:book_id] = single_book[:id]
    params[:borrowed_on] = Date.today
    params[:due_on] = Date.today + (Library.where(id: single_book[:library_id])[0].max_days)
    params[:user_id] = params[:request]
    params[:title] = single_book[:title]
    params.permit(:user_id, :isbn, :book_id, :borrowed_on, :due_on, :title)
  end

end
