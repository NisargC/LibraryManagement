class HoldRequestsController < ApplicationController
  before_action :set_hold_request, only: [:show, :edit, :update, :destroy]

  # GET /hold_requests
  # GET /hold_requests.json
  def index
    if session[:role] == 'student'
      @hold_requests = HoldRequest.where(user_id: session[:user_id])
    elsif session[:role] == 'librarian'
      librarian = Librarian.where(user_id: session[:user_id])[0]
      library = Library.where(id: librarian[:library_id])[0]
      books_in_library = Book.where(library_id: library[:id]).pluck(:isbn).to_a
      @hold_requests = HoldRequest.where(isbn: books_in_library)
    else
      @hold_requests = HoldRequest.all
    end

  end

  # GET /hold_requests/1
  # GET /hold_requests/1.json
  def show
  end

  # GET /hold_requests/new
  def new
    @hold_request = HoldRequest.new
  end

  # GET /hold_requests/1/edit
  def edit
  end

  # POST /hold_requests
  # POST /hold_requests.json
  def create
    @hold_request = HoldRequest.new(hold_request_params)

    respond_to do |format|
      if @hold_request.save
        format.html { redirect_to @hold_request, notice: 'Hold request was successfully created.' }
        format.json { render :show, status: :created, location: @hold_request }
      else
        format.html { render :new }
        format.json { render json: @hold_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hold_requests/1
  # PATCH/PUT /hold_requests/1.json
  def update
    respond_to do |format|
      if @hold_request.update(hold_request_params)
        format.html { redirect_to @hold_request, notice: 'Hold request was successfully updated.' }
        format.json { render :show, status: :ok, location: @hold_request }
      else
        format.html { render :edit }
        format.json { render json: @hold_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hold_requests/1
  # DELETE /hold_requests/1.json
  def destroy
    @hold_request.destroy
    respond_to do |format|
      format.html { redirect_to student_requests_path, notice: 'Hold request was deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hold_request
      @hold_request = HoldRequest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hold_request_params
      params.fetch(:hold_request, {})
    end
end
