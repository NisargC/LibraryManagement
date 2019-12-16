class ReturnBooksController < ApplicationController

  # GET /return_books
  # GET /return_books.json
  def index
    @return_books = BorrowedHistory.where(user_id: session[:user_id], returned_on: nil)
  end


  def re_assign_book(book)
    # code here
    hold_requests = HoldRequest.where(isbn: book[:isbn])
    hold_requests.each do |request|
      student = Student.where(user_id: request[:user_id]).limit(1)[0]

      if student[:borrow_count] < student[:max_books] && BorrowedHistory.where(user_id: student[:user_id], isbn: book[:isbn], returned_on: nil).size == 0

        BorrowedHistory.new(title: book[:title], book_id: book[:id], isbn: book[:isbn], user_id: student[:user_id], borrowed_on: Date.today, due_on: Date.today + (Library.where(id: book[:library_id])[0].max_days)).save
        student.update(borrow_count: student[:borrow_count] + 1)
        book.update(checked_out: true)
        request.delete
        studentUser = User.where(id: student[:user_id]).limit(1)[0]
        CheckoutDoneMailer.checkout_hold(studentUser, student, book).deliver_now
        return
      end
    end

  end

  def return
    begin
      borrow_history = BorrowedHistory.where(user_id: return_book_params[:user_id], returned_on: nil, isbn: return_book_params[:isbn])[0]
      borrow_history.update(returned_on: Date.today)
      student = Student.where(user_id: return_book_params[:user_id])[0]
      student.update(borrow_count: student[:borrow_count] - 1)
      book = Book.where(id: borrow_history[:book_id], checked_out: true).limit(1)[0]
      book.update(checked_out: false)

      respond_to do |format|
        format.html { redirect_to return_books_path, notice: 'Book was successfully returned.' }
        format.json { render :show, status: "returned", location: return_books_path }
      end
  rescue
    respond_to do |format|
        format.html { redirect_to return_books_path, notice: 'Some Error Occurred' }
      format.json { render status: "failed", status: :unprocessable_entity }
      end
    end
    re_assign_book(book)
  end

  def return_book_params
    params.permit(:user_id, :isbn)
  end
end
