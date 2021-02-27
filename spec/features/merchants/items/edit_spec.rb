require 'rails_helper'

RSpec.describe 'As a merchant, when I visit a Merchant Item Show Page' do
  before :each do
    @merchant = Merchant.third
    @item = @merchant.items.second
  end

  describe 'I can click a button to update that item' do
    it 'I am taken to an edit form with the current information pre-populated' do
      visit merchant_item_path(@merchant, @item)

      expect(page).to have_button("Update Item")
      click_button "Update Item"
      expect(current_path).to eq("/merchant/#{@merchant.id}/items/#{@item.id}/edit")

      expect(page).to have_field("name")
      expect(page).to have_field("description")
      expect(page).to have_field("unit_price")
    end

    it "and I can update that item and return to the item show page where I can see it's updated" do
      visit merchant_item_path(@merchant, @item)
      click_button "Update Item"
      fill_in "Name", with: "Updated Item Name"
      fill_in "Description", with: "This is new data"
      fill_in "unit_price", with: "300"
      click_button "Update Item"

      expect(current_path).to eq("/merchant/#{@merchant.id}/items/#{@item.id}")
      @item.reload
      expect(page).to have_content("#{@item.name} successfully updated")
      expect(page).to have_content("#{@item.description}")
      expect(page).to have_content("$300")
    end

    it 'I cannot update an item without a name' do
      visit merchant_item_path(@merchant, @item)
      click_button "Update Item"
      fill_in "Name", with: ""
      fill_in "Description", with: "This is new data"
      fill_in "unit_price", with: "300"
      click_button "Update Item"

      expect(current_path).to eq("/merchant/#{@merchant.id}/items/#{@item.id}")
      expect(page).to have_content("Name can't be blank")
    end

    it 'I cannot update an item without a current price or non numerical characters' do
      visit merchant_item_path(@merchant, @item)
      click_button "Update Item"
      fill_in "Name", with: "Updated Item Name"
      fill_in "Description", with: "This is new data"
      fill_in "unit_price", with: ""
      click_button "Update Item"

      expect(current_path).to eq("/merchant/#{@merchant.id}/items/#{@item.id}")
      expect(page).to have_content("Unit price can't be blank")
      expect(page).to have_content("Unit price is not a number")
    end
  end
end
