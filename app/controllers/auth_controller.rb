class AuthController < ApplicationController

  def login
    session[:user_id] = nil
    session[:name] = nil
    session[:role] = nil
  end

  def signup
    session[:user_id] = nil
    session[:name] = nil
    session[:role] = nil
  end

  def create
    user = User.where("email = ?",params[:user][:email]).pluck("email").first
    if user.eql?(params[:user][:email])
      flash[:notice] = "Email already registered!"
      redirect_to "/auth/login"
    elsif
    @role = user_params[:role]
    params[:user][:password] = Base64.encode64(params[:user][:password])
    if @role.eql?("Librarian")

      params[:user][:role] = 1
      @user = User.new(user_params)
      @user.save

      user = User.where("email = ?",params[:user][:email])
      params[:user][:status] = 0
      params[:user][:user_id] = user.pluck("id").first
      @request = Request.new(request_params);
      @request.save

      flash[:redirectFromSU] = 1
      flash[:user_id] = user.pluck("id").first
      redirect_to new_librarian_url

    else

      params[:user][:role] = 2
      @user = User.new(user_params)
      @user.save

      user = User.where("email = ?",params[:user][:email])
      flash[:redirectFromSU] = 1
      flash[:user_id] = user.pluck("id").first
      flash[:tmp_id] = flash[:user_id]
      redirect_to new_student_url
      puts flash[:user_id]

    end
    end
  end

  def authorize
    user = User.where("email = ?",params[:user][:email])

    if user.size != 0
      request = Request.where("user_id = ?",user.pluck("id").first).where("isbn = ?",:nil).pluck("status").first

      if request==0
        flash[:notice]= "We are sorry. But your request has not been approved yet!"
        redirect_to "/auth/login"
      else
        password = Base64.decode64(user.pluck("password").first)

        if password.eql? params[:user][:password]
          session[:user_id] = user.pluck("id").first
          session[:name] = user.pluck("name").first
          user_role = user.pluck("role").first
          if user_role== 0
            session[:role] = "admin"
            redirect_to "/users/"+user.pluck("id")[0].to_s
          elsif user_role==1
            session[:role] = "librarian"
            librarian_id = Librarian.where("user_id = ?",session[:user_id]).pluck("id").first
            redirect_to "/librarians/"+librarian_id.to_s
          elsif user_role == 2
            session[:role] = "student"
            student_id = Student.where("user_id = ?",session[:user_id]).pluck("id").first
            redirect_to "/students/"+student_id.to_s
          end
        else
          flash[:notice] = "Email or password is invalid"
          redirect_to "/auth/login"
        end
      end
    else
      flash[:notice] = "Email not registered!"
      redirect_to "/auth/signup"
    end
  end

  def user_params
    params.require(:user).permit(:email, :name, :password, :role,:request)
  end

  def request_params
    params.require(:user).permit(:user_id,:status)
  end

  def destroy
    session[:user_id] = nil
    session[:name] = nil
    session[:role] = nil
    redirect_to '/auth/login'
  end

end
