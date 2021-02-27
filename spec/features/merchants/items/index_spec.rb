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
      expect(page).to have_content(@items.first.name)
    end
  end

  it 'I do not see items for another merchant' do
    visit merchant_items_path(@merchant)
    merchant2 = Merchant.second
    item = merchant2.items.first

    expect(page).to_not have_content("#{item.name}")
  end

  it "each item name is a link to that item's show page" do
    item = @merchant.items.first
    visit merchant_items_path(@merchant)

    within "#item-#{item.id}" do
      expect(page).to have_link("#{item.name}")
      click_link "#{item.name}"
      expect(current_path).to eq("/merchant/#{@merchant.id}/items/#{item.id}")
    end
  end

  it "I see a button to create a new item" do
    visit merchant_items_path(@merchant)

    expect(page).to have_button("Create Item")
    click_button "Create Item"
    expect(current_path).to eq("/merchant/#{@merchant.id}/items/new")
  end

  it "in my list of items they are grouped by status" do
    @items.first.update!(status: :disabled)
    @items.second.update!(status: :disabled)
    @items.third.update!(status: :disabled)
    visit merchant_items_path(@merchant)

    within ".enabled-items" do
      expect(page.all('a', text: 'Item').count).to eq(23)
      expect(page).to have_content("#{@items.fourth.name}")
      expect(page).to_not have_content("#{@items.first.name}")
    end

    within ".disabled-items" do
      expect(page.all('a', text: 'Item').count).to eq(3)
      expect(page).to_not have_content("#{@items.fourth.name}")
      expect(page).to have_content("#{@items.first.name}")
      expect(page).to have_content("#{@items.second.name}")
      expect(page).to have_content("#{@items.third.name}")
    end
  end

  it "next to each item there is either a button to enable or disable it" do
    visit merchant_items_path(@merchant)

    within ".enabled-items" do
      within "#item-#{@items.fourth.id}" do
        expect(page).to have_button("Disable")
        click_button "Disable"
      end
      expect(page).to_not have_content("#{@items.fourth.name}")
    end

    within ".disabled-items" do
      within "#item-#{@items.fourth.id}" do
        expect(page).to have_content("#{@items.fourth.name}")
        expect(page).to have_button("Enable")
        click_button "Enable"
      end
      expect(page).to_not have_content("#{@items.fourth.name}")
    end
  end
end
