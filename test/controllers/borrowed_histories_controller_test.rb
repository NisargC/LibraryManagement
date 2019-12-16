require 'test_helper'

class BorrowedHistoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @borrowed_history = borrowed_histories(:one)
  end

  test "should get index" do
    get borrowed_histories_url
    assert_response :success
  end

  test "should get new" do
    get new_borrowed_history_url
    assert_response :success
  end

  test "should create borrowed_history" do
    assert_difference('BorrowedHistory.count') do
      post borrowed_histories_url, params: { borrowed_history: {  } }
    end

    assert_redirected_to borrowed_history_url(BorrowedHistory.last)
  end

  test "should show borrowed_history" do
    get borrowed_history_url(@borrowed_history)
    assert_response :success
  end

  test "should get edit" do
    get edit_borrowed_history_url(@borrowed_history)
    assert_response :success
  end

  test "should update borrowed_history" do
    patch borrowed_history_url(@borrowed_history), params: { borrowed_history: {  } }
    assert_redirected_to borrowed_history_url(@borrowed_history)
  end

  test "should destroy borrowed_history" do
    assert_difference('BorrowedHistory.count', -1) do
      delete borrowed_history_url(@borrowed_history)
    end

    assert_redirected_to borrowed_histories_url
  end
end
