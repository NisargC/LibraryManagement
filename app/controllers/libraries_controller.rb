class LibrariesController < ApplicationController
  before_action :set_library, only: [:show, :edit, :update, :destroy]

  # GET /libraries
  # GET /libraries.json
  def index
    if session[:role] == 'admin' || session[:role] == 'student'
      @libraries = Library.all
    elsif session[:role] == 'librarian'
      @libraries = Library.where(id: Librarian.where(user_id: session[:user_id]).pluck(:library_id))
    end
  end

  # GET /libraries/1
  # GET /libraries/1.json
  def show
  end

  # GET /libraries/new
  def new
    @library = Library.new
  end

  # GET /libraries/1/edit
  def edit
  end

  # POST /libraries
  # POST /libraries.json
  def create
    @library = Library.new(library_params)

    respond_to do |format|
      if @library.save
        format.html { redirect_to @library, notice: 'Library was successfully created.' }
        format.json { render :show, status: :created, location: @library }
      else
        format.html { render :new }
        format.json { render json: @library.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    books = Book.where(id: @library.id)
    flag = 0
    books.each do |book|
      if book.checked_out == TRUE
      respond_to do |format|
        format.html { redirect_to libraries_path, notice: 'Library cannot be destroyed as it has checked out book.' }
        format.json { head :no_content }
        flag = 1
      end
      end
    end
    if flag.zero?
      @library.destroy
      respond_to do |format|
        format.html { redirect_to libraries_path, notice: 'Library was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end
  # PATCH/PUT /libraries/1
  # PATCH/PUT /libraries/1.json
  def update
    respond_to do |format|
      if @library.update(library_params)
        format.html { redirect_to @library, notice: 'Library was successfully updated.' }
        format.json { render :show, status: :ok, location: @library }
      else
        format.html { render :edit }
        format.json { render json: @library.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_library
    @library = Library.find(params[:id])
  end

    # Never trust parameters from the scary internet, only allow the white list through.
  def library_params
    params.fetch(:library).permit(:name, :university, :location, :max_days, :overdue_fines)
  end
end
