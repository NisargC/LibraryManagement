require "application_system_test_case"

class ReturnBooksTest < ApplicationSystemTestCase
  setup do
    @return_book = return_books(:one)
  end

  test "visiting the index" do
    visit return_books_url
    assert_selector "h1", text: "Return Books"
  end

  test "creating a Return book" do
    visit return_books_url
    click_on "New Return Book"

    click_on "Create Return book"

    assert_text "Return book was successfully created"
    click_on "Back"
  end

  test "updating a Return book" do
    visit return_books_url
    click_on "Edit", match: :first

    click_on "Update Return book"

    assert_text "Return book was successfully updated"
    click_on "Back"
  end

  test "destroying a Return book" do
    visit return_books_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Return book was successfully destroyed"
  end
end
