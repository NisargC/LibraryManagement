require "application_system_test_case"

class AuthoirizationsTest < ApplicationSystemTestCase
  setup do
    @authoirization = authoirizations(:one)
  end

  test "visiting the index" do
    visit authoirizations_url
    assert_selector "h1", text: "Authoirizations"
  end

  test "creating a Authoirization" do
    visit authoirizations_url
    click_on "New Authoirization"

    click_on "Create Authoirization"

    assert_text "Authoirization was successfully created"
    click_on "Back"
  end

  test "updating a Authoirization" do
    visit authoirizations_url
    click_on "Edit", match: :first

    click_on "Update Authoirization"

    assert_text "Authoirization was successfully updated"
    click_on "Back"
  end

  test "destroying a Authoirization" do
    visit authoirizations_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Authoirization was successfully destroyed"
  end
end
