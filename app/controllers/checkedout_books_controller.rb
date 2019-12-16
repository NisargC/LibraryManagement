class CheckedoutBooksController < ApplicationController
  before_action :set_checkedout_book, only: [:show, :edit, :update, :destroy]

  # GET /checkedout_books
  # GET /checkedout_books.json
  def index
    if(session[:role] == 'admin')
      @checkedout_books = BorrowedHistory.where(returned_on: nil)
    elsif(session[:role] == 'librarian')
      library = Librarian.where(user_id: session[:user_id]).limit(1)[0][:library_id]
      puts library
      books = Book.where(library_id: library).to_a.collect {|x| x[:isbn]}
      @checkedout_books = BorrowedHistory.where(returned_on: nil, isbn:books)
    elsif(session[:role] == 'student')
      @checkedout_books = BorrowedHistory.where(returned_on: nil, user_id: session[:user_id])
    end

  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_checkedout_book
      @checkedout_book = CheckedoutBook.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def checkedout_book_params
      params.fetch(:checkedout_book, {})
    end
end
