require "application_system_test_case"

class BorrowedHistoriesTest < ApplicationSystemTestCase
  setup do
    @borrowed_history = borrowed_histories(:one)
  end

  test "visiting the index" do
    visit borrowed_histories_url
    assert_selector "h1", text: "Borrowed Histories"
  end

  test "creating a Borrowed history" do
    visit borrowed_histories_url
    click_on "New Borrowed History"

    click_on "Create Borrowed history"

    assert_text "Borrowed history was successfully created"
    click_on "Back"
  end

  test "updating a Borrowed history" do
    visit borrowed_histories_url
    click_on "Edit", match: :first

    click_on "Update Borrowed history"

    assert_text "Borrowed history was successfully updated"
    click_on "Back"
  end

  test "destroying a Borrowed history" do
    visit borrowed_histories_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Borrowed history was successfully destroyed"
  end
end
