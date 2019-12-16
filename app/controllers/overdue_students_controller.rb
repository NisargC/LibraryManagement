class OverdueStudentsController < ApplicationController
  def index
    if session[:role] == 'student'
      student = Student.where(user_id: session[:user_id])[0]
      @overdue = BorrowedHistory.where("returned_on > due_on or returned_on is NULL" ).where(user_id: student[:user_id])
    elsif session[:role] == 'librarian'
      librarian = Librarian.where(user_id: session[:user_id])[0]
      library = Library.where(id: librarian[:library_id])[0]
      books_in_library = Book.where(library_id: library[:id]).pluck(:isbn).to_a
      @overdue = BorrowedHistory.where("returned_on > due_on or returned_on is NULL" ).where(isbn: books_in_library)
    else
      @overdue = BorrowedHistory.where("returned_on > due_on or returned_on is NULL" )
    end
    @users_with_overdues = Hash.new(0)
    @overdue.each do |t|
      if(t[:returned_on] == nil && Date.today > t[:due_on])
        fine = (((Date.today - t[:due_on]).to_i) * Library.where(id:Book.where(id:t[:book_id])[0].library_id)[0].overdue_fines)
        @users_with_overdues[t[:user_id]] += fine
      elsif(t[:returned_on] != nil )
        fine = (((t[:returned_on] - t[:due_on]).to_i) * Library.where(id:Book.where(id:t[:book_id])[0].library_id)[0].overdue_fines)
        @users_with_overdues[t[:user_id]] += fine
      end
    end
    if (session[:role] == 'student' && @overdue.size == 0)
      @users_with_overdues[session[:user_id]] = 0.0
    end
  end
end
