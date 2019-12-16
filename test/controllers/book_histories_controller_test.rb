require 'test_helper'

class BookHistoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book_history = book_histories(:one)
  end

  test "should get index" do
    get book_histories_url
    assert_response :success
  end

  test "should get new" do
    get new_book_history_url
    assert_response :success
  end

  test "should create book_history" do
    assert_difference('BookHistory.count') do
      post book_histories_url, params: { book_history: {  } }
    end

    assert_redirected_to book_history_url(BookHistory.last)
  end

  test "should show book_history" do
    get book_history_url(@book_history)
    assert_response :success
  end

  test "should get edit" do
    get edit_book_history_url(@book_history)
    assert_response :success
  end

  test "should update book_history" do
    patch book_history_url(@book_history), params: { book_history: {  } }
    assert_redirected_to book_history_url(@book_history)
  end

  test "should destroy book_history" do
    assert_difference('BookHistory.count', -1) do
      delete book_history_url(@book_history)
    end

    assert_redirected_to book_histories_url
  end
end
