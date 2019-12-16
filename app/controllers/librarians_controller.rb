class LibrariansController < ApplicationController
  before_action :create_auth
  before_action :set_librarian, only: [:show, :edit, :update, :destroy]

  def create_auth
    if session[:role] == 'student'
      flash[:notice] = 'You are not allowed to do this transaction.'
      redirect_to(students_url) && return
    end
    if session[:role] != 'admin'
      if !params[:id].nil? && params[:id].to_i != Librarian.where(user_id: session[:user_id]).pluck(:id)[0]
        flash[:notice] = 'You are not allowed to do this transaction.'
        redirect_to librarians_url
      end
    end
  end

  # GET /librarians
  # GET /librarians.json
  def index
    if search_params[:what].nil?
      @librarians = Librarian.where.not(library_id: 0)
    else
      @librarians = Librarian.where.not(library_id: 0).where(user_id: User.where(name: search_params[:what]).pluck(:id))
    end
  end

  # GET /librarians/1
  # GET /librarians/1.json
  def show
    @librarian = Librarian.find(params[:id])
  end

  # GET /librarians/new
  def new
    @librarian = Librarian.new
  end

  # GET /librarians/1/edit
  def edit
  end

  # POST /librarians
  # POST /librarians.json
  def create

    if flash[:redirectFromSU] !=1
      params[:librarian][:request] = 0
      params[:librarian][:role] = 1
      @user = User.new(librarian_user_params)

      user = User.where("email = ? ",params[:librarian][:email])

      if user.size !=0
        respond_to do |format|
          format.html { redirect_to librarians_path, notice: 'Email already present. Try creating with a different email!'  and return }
        end
      end

      @user.save
      @id = User.where("email = ?",params[:librarian][:email]).pluck("id").first
      params[:librarian][:user_id] = @id
    end
    @librarian = Librarian.new(librarian_params)

    respond_to do |format|
      if @librarian.save
        if flash[:redirectFromSU] == 1
          format.html { redirect_to "/auth/login", notice: 'Librarian was successfully created. Request sent to admin!' }
        else
        format.html { redirect_to @librarian, notice: 'Librarian was successfully created!' }
        format.json { render :show, status: :created, location: @librarian }
        end
      else
        format.html { render :new }
        format.json { render json: @librarian.errors, status: :unprocessable_entity }
      end
    end

  end

  # PATCH/PUT /librarians/1
  # PATCH/PUT /librarians/1.json
  def update

    respond_to do |format|
      user = User.where("email = ? ",params[:librarian][:email]).pluck("email")
      lib = User.where("id = ?",params[:librarian][:user_id]).pluck("email")

      puts user.inspect
      puts lib.inspect
      puts user.size
      if (user.size == 0 || user == lib)
        if @librarian.update(librarian_params) && User.find(@librarian.user_id).update(librarian_user_params)
          format.html { redirect_to @librarian, notice: 'Librarian was successfully updated.' }
          format.json { render :show, status: :ok, location: @librarian }
        else
          format.html { render :edit }
          format.json { render json: @librarian.errors, status: :unprocessable_entity }
        end
      elsif user.size!=0
        puts 'fuck lib'
        format.html { redirect_to edit_librarian_path(@librarian), notice: 'Email already present, cannot update to given email!' }
      else
        format.html { render :edit }
        format.json { render json: @librarian.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /librarians/1
  # DELETE /librarians/1.json
  def destroy

    @user = User.where("id = ?",@librarian[:user_id]).pluck("id")
    @librarian.destroy
    User.destroy(@user)
    respond_to do |format|
      if session[:role] == "admin"
        format.html { redirect_to librarians_url, notice: 'Librarian was successfully destroyed.' }
      elsif session[:role] == "librarian"
        format.html { redirect_to "/auth/destroy", notice: 'Librarian was successfully destroyed.' }
      end
        format.json { head :no_content }
     end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_librarian
    @librarian = Librarian.find(params[:id])
  end

    # Never trust parameters from the scary internet, only allow the white list through.

  def search_params
    if !params[:search].nil?
      params.fetch(:search).permit(:what)
    else
      params
    end
  end

  def librarian_params
    params.fetch(:librarian).permit( :library_id,:user_id)
  end

  def librarian_user_params
    params[:librarian][:password] = Base64.encode64(params[:librarian][:password])
    params.require(:librarian).permit(:email, :name, :password, :role,:request)
  end

end