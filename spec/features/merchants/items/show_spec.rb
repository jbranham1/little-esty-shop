require 'rails_helper'

RSpec.describe 'As a merchant, when I visit my Merchant Items Index Page' do
  before :each do
    @merchant = Merchant.third
    @item = @merchant.items.second
  end

  describe 'and I click on a link to a single item' do
    it 'I am taken to that item show page and I see its details' do
      visit merchant_item_path(@merchant, @item)
      # price = (@item.unit_price.to_i).to_s
      # price = price

      expect(page).to have_content("#{@item.name}")
      expect(page).to have_content("Description: #{@item.description}")
      expect(page).to have_content("Current Price: $74,550")
    end

    it ' on the item show page I see a button to update that item' do
      visit merchant_item_path(@merchant, @item)

      expect(page).to have_button("Update Item")
      click_button "Update Item"
      expect(current_path).to eq("/merchant/#{@merchant.id}/items/#{@item.id}/edit")
    end
  end
end
