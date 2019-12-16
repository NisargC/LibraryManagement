class StudentsController < ApplicationController
  before_action :create_auth
  before_action :set_student, only: %i[show edit update destroy]

  def create_auth
    if session[:role] == 'librarian'
      flash[:notice] = 'You are not allowed to do this transaction.'
      redirect_to(librarians_url) && return
    end
    if session[:role] != 'admin'
      if !params[:id].nil? && params[:id].to_i != Student.where(user_id: session[:user_id]).pluck(:id)[0]
        flash[:notice] = 'You are not allowed to do this transaction.'
        redirect_to students_url
      end
    end
  end

  # GET /students
  # GET /students.json
  def index
    if search_params[:what].nil?
      @students = Student.where.not(education_level: [nil, 'None'])
    else
      @students = Student.where.not(education_level: [nil, 'None']).where(user_id: User.where(name: search_params[:what]).pluck(:id))

    end
    @students.each do |student|
      overdue = BorrowedHistory.where("returned_on > due_on or returned_on is NULL" ).where(user_id: student[:user_id])
      totalFine = 0
      overdue.each do |t|
        if(t[:returned_on] == nil && Date.today > t[:due_on])
          fine = (((Date.today - t[:due_on]).to_i) * Library.where(id:Book.where(id:t[:book_id])[0].library_id)[0].overdue_fines)
          totalFine += fine
        elsif(t[:returned_on] != nil )
          fine = (((t[:returned_on] - t[:due_on]).to_i) * Library.where(id:Book.where(id:t[:book_id])[0].library_id)[0].overdue_fines)
          totalFine += fine
        end
      end
      student[:dues] = totalFine

    end
  end

  # GET /students/1
  # GET /students/1.json

  def show
    overdue = BorrowedHistory.where("returned_on > due_on or returned_on is NULL" ).where(user_id: @student[:user_id])
    totalFine = 0
    overdue.each do |t|
      if(t[:returned_on] == nil && Date.today > t[:due_on])
        fine = (((Date.today - t[:due_on]).to_i) * Library.where(id:Book.where(id:t[:book_id])[0].library_id)[0].overdue_fines)
        totalFine += fine
      elsif(t[:returned_on] != nil )
        fine = (((t[:returned_on] - t[:due_on]).to_i) * Library.where(id:Book.where(id:t[:book_id])[0].library_id)[0].overdue_fines)
        totalFine += fine
      end
    end
    @student[:dues] = totalFine
  end


  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit; end

  # POST /students
  # POST /students.json
  def create
    @student = Student.new(student_params)

    if flash[:redirectFromSU] !=1
      params[:student][:request] = 0
      params[:student][:role] = 2
      @user = User.new(student_user_params)
      user = User.where("email = ? ",params[:student][:email])

      if user.size !=0
        respond_to do |format|
          format.html { redirect_to students_path, notice: 'Email already present. Try creating with a different email!'  and return }
        end
      end

      @user.save
      @id = User.where('email = ?',params[:student][:email]).pluck('id').first
      params[:student][:user_id] = @id
    end

    @student = Student.new(student_params)
    respond_to do |format|
      if @student.save
        if flash[:redirectFromSU] == 1
          format.html { redirect_to '/auth/login', notice: 'Student was successfully created.' }
        else
          format.html { redirect_to @student, notice: 'Student was successfully created.' }
          format.json { render :show, status: :created, location: @student }
        end
      else
        format.html { render :new }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    respond_to do |format|
      user = User.where("email = ? ",params[:student][:email]).pluck("email")
      student = User.where("id = ?",params[:student][:user_id]).pluck"email"

      if (user.size == 0 || user == student)
        if @student.update(student_params) && User.find(@student.user_id).update(student_user_params)
          format.html { redirect_to @student, notice: 'Student was successfully updated.' }
          format.json { render :show, status: :ok, location: @student }
        else
          format.html { render :edit }
          format.json { render json: @student.errors, status: :unprocessable_entity }
        end
      elsif user.size!=0
        format.html { redirect_to edit_student_path(@student), notice: 'Email already present, cannot update to given email!' }
      else
        format.html { render :edit }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json

  def delete_list object
    @classOfObject = object.class.to_s
    classCurrent = @classOfObject[0,@classOfObject.index(':')]
    object.each do |o|
      classCurrent.constantize.destroy(o.id)
    end
  end


  def destroy
    if session[:role] == 'librarian'
      redirect_to Librarian.where(user_id: session[:user_id]).limit(1)[0]
    end
    if @student[:borrow_count].zero? and (@student[:dues].nil? or @student[:dues].zero?)

      bookmark = Bookmark.where("user_id = ?",@student[:user_id])
      requests = Request.where("user_id = ?",@student[:user_id])
      hold_requests = HoldRequest.where("user_id = ?",@student[:user_id])

      delete_list requests
      delete_list hold_requests
      delete_list bookmark

      Student.destroy(@student[:id])
      User.destroy(@student[:user_id])

      respond_to do |format|
        if session[:role]  == "admin"
          format.html { redirect_to students_url, notice: 'Student was successfully destroyed.' }
        elsif session[:role] == "student"
          format.html { redirect_to "/auth/destroy", notice: 'Student was successfully destroyed.' }
        end
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        if session[:role] == "admin"
          format.html { redirect_to students_url, notice: 'Cannot delete account. Return all the checked out books and pay the pending dues to delete account.' }
        elsif session[:role] == "student"
          format.html { redirect_to student_path, notice: 'Cannot delete account. Return all the checked out books and pay the pending dues to delete account.' }
        end
        format.json { head :no_content }

      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_student
    @student = Student.find(params[:id])
  end

    # Never trust parameters from the scary internet, only allow the white list through.

  def search_params
    if !params[:search].nil?
      params.fetch(:search).permit(:what)
    else
      params
    end
  end

  def student_user_params
    params[:student][:role] = 2
    params[:student][:password] = Base64.encode64(params[:student][:password])
    params.fetch(:student).permit(:name, :email, :password, :role, :request)
  end

  def student_params
<<<<<<< HEAD
    if params.fetch(:student)[:education_level] == "Masters"
      maxBook = 4
      params[:student][:max_books] = maxBook
    elsif params.fetch(:student)[:education_level] == "PhD"
      params[:student][:max_books] = maxBook
      maxBook = 6
    else
      maxBook = 2
      params[:student][:max_books] = maxBook
    end

=======
    maxBook = 2
    if params.fetch(:student)[:education_level] == "Masters"
      maxBook = 4
    elsif params.fetch(:student)[:education_level] == "PhD"
      maxBook = 6
    end
    params[:student][:max_books] = maxBook
>>>>>>> Stopped invalid routes and stopped accessing other users
    params[:student][:borrow_count] = 0
    params.fetch(:student).permit(:user_id, :borrow_count, :dues, :max_books, :borrow_count, :education_level, :university )
  end
end
