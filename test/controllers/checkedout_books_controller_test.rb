require 'test_helper'

class CheckedoutBooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @checkedout_book = checkedout_books(:one)
  end

  test "should get index" do
    get checkedout_books_url
    assert_response :success
  end

  test "should get new" do
    get new_checkedout_book_url
    assert_response :success
  end

  test "should create checkedout_book" do
    assert_difference('CheckedoutBook.count') do
      post checkedout_books_url, params: { checkedout_book: {  } }
    end

    assert_redirected_to checkedout_book_url(CheckedoutBook.last)
  end

  test "should show checkedout_book" do
    get checkedout_book_url(@checkedout_book)
    assert_response :success
  end

  test "should get edit" do
    get edit_checkedout_book_url(@checkedout_book)
    assert_response :success
  end

  test "should update checkedout_book" do
    patch checkedout_book_url(@checkedout_book), params: { checkedout_book: {  } }
    assert_redirected_to checkedout_book_url(@checkedout_book)
  end

  test "should destroy checkedout_book" do
    assert_difference('CheckedoutBook.count', -1) do
      delete checkedout_book_url(@checkedout_book)
    end

    assert_redirected_to checkedout_books_url
  end
end
