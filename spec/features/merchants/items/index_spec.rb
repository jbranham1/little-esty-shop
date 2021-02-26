require 'rails_helper'

RSpec.describe 'As a merchant, when I vist my Merchant Items Index Page' do
  before :each do
    @merchant = Merchant.third
    @items = @merchant.items
  end

  it 'I see a list of the names of all of my items' do
    visit merchant_items_path(@merchant)
    expect(page).to have_content("My Items")

    within '.all-items' do
      expect(page.all('a', text: 'Item').count).to eq(26)
    end
  end

  it 'each item name is a link to that item show page' do
    item = @merchant.items.first
    visit merchant_items_path(@merchant)

    within "#item-#{item.id}" do
      expect(page).to have_link("#{item.name}")
      click_link "#{item.name}"
      expect(current_path).to eq("/merchant/#{@merchant.id}/items/#{item.id}")
    end
  end
end
