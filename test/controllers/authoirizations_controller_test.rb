require 'test_helper'

class AuthoirizationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @authoirization = authoirizations(:one)
  end

  test "should get index" do
    get authoirizations_url
    assert_response :success
  end

  test "should get new" do
    get new_authoirization_url
    assert_response :success
  end

  test "should create authoirization" do
    assert_difference('Authoirization.count') do
      post authoirizations_url, params: { authoirization: {  } }
    end

    assert_redirected_to authoirization_url(Authoirization.last)
  end

  test "should show authoirization" do
    get authoirization_url(@authoirization)
    assert_response :success
  end

  test "should get edit" do
    get edit_authoirization_url(@authoirization)
    assert_response :success
  end

  test "should update authoirization" do
    patch authoirization_url(@authoirization), params: { authoirization: {  } }
    assert_redirected_to authoirization_url(@authoirization)
  end

  test "should destroy authoirization" do
    assert_difference('Authoirization.count', -1) do
      delete authoirization_url(@authoirization)
    end

    assert_redirected_to authoirizations_url
  end
end
