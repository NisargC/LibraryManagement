require "application_system_test_case"

class HoldRequestsTest < ApplicationSystemTestCase
  setup do
    @hold_request = hold_requests(:one)
  end

  test "visiting the index" do
    visit hold_requests_url
    assert_selector "h1", text: "Hold Requests"
  end

  test "creating a Hold request" do
    visit hold_requests_url
    click_on "New Hold Request"

    click_on "Create Hold request"

    assert_text "Hold request was successfully created"
    click_on "Back"
  end

  test "updating a Hold request" do
    visit hold_requests_url
    click_on "Edit", match: :first

    click_on "Update Hold request"

    assert_text "Hold request was successfully updated"
    click_on "Back"
  end

  test "destroying a Hold request" do
    visit hold_requests_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Hold request was successfully destroyed"
  end
end
