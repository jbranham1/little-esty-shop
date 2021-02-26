require 'rails_helper'

RSpec.describe 'As a merchant, when I vist my Merchant Items Index Page' do
  before :each do
    @merchant = Merchant.third
    @item = @merchant.items.second
  end

  describe 'and I click on a link to a single item from my merchant items index' do
    it 'I am taken to that item show page and I see its details' do
      visit merchant_item_path(@merchant, @item)
      # price = (@item.unit_price.to_i).to_s
      # price = price

      expect(page).to have_content("#{@item.name}")
      expect(page).to have_content("Description: #{@item.description}")
      expect(page).to have_content("Current Price: $74,550")
    end
  end
end
