require 'test_helper'

class ReturnBooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @return_book = return_books(:one)
  end

  test "should get index" do
    get return_books_url
    assert_response :success
  end

  test "should get new" do
    get new_return_book_url
    assert_response :success
  end

  test "should create return_book" do
    assert_difference('ReturnBook.count') do
      post return_books_url, params: { return_book: {  } }
    end

    assert_redirected_to return_book_url(ReturnBook.last)
  end

  test "should show return_book" do
    get return_book_url(@return_book)
    assert_response :success
  end

  test "should get edit" do
    get edit_return_book_url(@return_book)
    assert_response :success
  end

  test "should update return_book" do
    patch return_book_url(@return_book), params: { return_book: {  } }
    assert_redirected_to return_book_url(@return_book)
  end

  test "should destroy return_book" do
    assert_difference('ReturnBook.count', -1) do
      delete return_book_url(@return_book)
    end

    assert_redirected_to return_books_url
  end
end
