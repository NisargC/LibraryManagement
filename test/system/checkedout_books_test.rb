require "application_system_test_case"

class CheckedoutBooksTest < ApplicationSystemTestCase
  setup do
    @checkedout_book = checkedout_books(:one)
  end

  test "visiting the index" do
    visit checkedout_books_url
    assert_selector "h1", text: "Checkedout Books"
  end

  test "creating a Checkedout book" do
    visit checkedout_books_url
    click_on "New Checkedout Book"

    click_on "Create Checkedout book"

    assert_text "Checkedout book was successfully created"
    click_on "Back"
  end

  test "updating a Checkedout book" do
    visit checkedout_books_url
    click_on "Edit", match: :first

    click_on "Update Checkedout book"

    assert_text "Checkedout book was successfully updated"
    click_on "Back"
  end

  test "destroying a Checkedout book" do
    visit checkedout_books_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Checkedout book was successfully destroyed"
  end
end
