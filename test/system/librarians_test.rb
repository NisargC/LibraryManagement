require "application_system_test_case"

class LibrariansTest < ApplicationSystemTestCase
  setup do
    @librarian = librarians(:one)
  end

  test "visiting the index" do
    visit librarians_url
    assert_selector "h1", text: "Librarians"
  end

  test "creating a Librarian" do
    visit librarians_url
    click_on "New Librarian"

    click_on "Create Librarian"

    assert_text "Librarian was successfully created"
    click_on "Back"
  end

  test "updating a Librarian" do
    visit librarians_url
    click_on "Edit", match: :first

    click_on "Update Librarian"

    assert_text "Librarian was successfully updated"
    click_on "Back"
  end

  test "destroying a Librarian" do
    visit librarians_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Librarian was successfully destroyed"
  end
end
