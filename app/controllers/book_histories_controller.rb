class BookHistoriesController < ApplicationController

  # GET /book_histories
  # GET /book_histories.json
  def index
    if session[:role] == 'student'
      borrowed_histories = []
    elsif session[:role] == 'librarian'
      librarian = Librarian.where(user_id: session[:user_id])[0]
      library = Library.where(id: librarian[:library_id])[0]
      books_in_library = Book.where(library_id: library[:id]).pluck(:isbn).to_a
      borrowed_histories = BorrowedHistory.where(isbn: books_in_library)
    else
      borrowed_histories = BorrowedHistory.order(:borrowed_on)
    end


    @book_histories = Hash.new { |h, k| h[k] = Array.new }
    borrowed_histories.each do |history|
      @book_histories[history[:isbn]].insert(-1, User.where(id: history[:user_id]).limit(1)[0].name)
    end

  end


end
