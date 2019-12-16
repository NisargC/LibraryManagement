class UsersController < ApplicationController
  before_action :create_auth

  def create_auth
    puts params[:id].to_i != session[:user_id]
    if session[:role] != 'admin'
      if !params[:id].nil? && params[:id].to_i != session[:user_id]
        flash[:notice] = 'You are not allowed to do this transaction.'
        redirect_to students_url
      end
    end
  end

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @student = Student.where("user_id = ?",params[:id])
    @librarian = Librarian.where("user_id = ?",params[:id])
  end

  # PATCH/PUT /user/1
  # PATCH/PUT /user/1.json
  def update
    respond_to do |format|
      @user = User.where(id: params[:user][:id])[0]
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'Admin was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    role = session[:role]
    if role == "admin"
      @user = User.find(session[:user_id])
    elsif role == "librarian"
      @librarian = Librarian.where("user_id = ?",session[:user_id])
      redirect_to edit_librarian_path(@librarian.pluck("id").first)
    elsif role == "student"
      @student = Student.where("user_id = ?",session[:user_id])
      redirect_to edit_student_path(@student.pluck("id").first)
    end
  end

  def user_params
    params.fetch(:user).permit(:name, :email, :id)
  end

  def destroy
    @user.destroy
  end
end
