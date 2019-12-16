require 'test_helper'

class HoldRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hold_request = hold_requests(:one)
  end

  test "should get index" do
    get hold_requests_url
    assert_response :success
  end

  test "should get new" do
    get new_hold_request_url
    assert_response :success
  end

  test "should create hold_request" do
    assert_difference('HoldRequest.count') do
      post hold_requests_url, params: { hold_request: {  } }
    end

    assert_redirected_to hold_request_url(HoldRequest.last)
  end

  test "should show hold_request" do
    get hold_request_url(@hold_request)
    assert_response :success
  end

  test "should get edit" do
    get edit_hold_request_url(@hold_request)
    assert_response :success
  end

  test "should update hold_request" do
    patch hold_request_url(@hold_request), params: { hold_request: {  } }
    assert_redirected_to hold_request_url(@hold_request)
  end

  test "should destroy hold_request" do
    assert_difference('HoldRequest.count', -1) do
      delete hold_request_url(@hold_request)
    end

    assert_redirected_to hold_requests_url
  end
end
