require "application_system_test_case"

class BookHistoriesTest < ApplicationSystemTestCase
  setup do
    @book_history = book_histories(:one)
  end

  test "visiting the index" do
    visit book_histories_url
    assert_selector "h1", text: "Book Histories"
  end

  test "creating a Book history" do
    visit book_histories_url
    click_on "New Book History"

    click_on "Create Book history"

    assert_text "Book history was successfully created"
    click_on "Back"
  end

  test "updating a Book history" do
    visit book_histories_url
    click_on "Edit", match: :first

    click_on "Update Book history"

    assert_text "Book history was successfully updated"
    click_on "Back"
  end

  test "destroying a Book history" do
    visit book_histories_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Book history was successfully destroyed"
  end
end
