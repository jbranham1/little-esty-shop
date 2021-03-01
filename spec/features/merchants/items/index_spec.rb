require 'rails_helper'

RSpec.describe 'As a merchant, when I visit my Merchant Items Index Page' do
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

  describe "and there is a section for Top 5 Items" do
    it 'where I see a list ranked based on total revenue' do
      merchant = Merchant.first
      item1 = Item.find(3)
      item2 = Item.find(13)
      item3 = Item.find(1)
      item4 = Item.find(6)
      item5 = Item.find(5)
      visit merchant_items_path(merchant)

      within ".top-items" do
        expect(page).to have_content("#{item1.name}")
        expect(item3.name).to appear_before(item1.name)
        expect(item1.name).to appear_before(item5.name)
        expect(item5.name).to appear_before(item2.name)
        expect(item2.name).to appear_before(item4.name)
      end
    end

    it "each of the item names are links to that item's show page" do
      merchant = Merchant.first
      item1 = Item.find(13)
      visit merchant_items_path(merchant)

      within ".top-items" do
        expect(page.all('a', text: 'Item').count).to eq(5)
        within "#item-#{item1.id}" do
          click_link "#{item1.name}"
          expect(current_path).to eq("/merchant/#{merchant.id}/items/#{item1.id}")
        end
      end
    end

    it "below each of those items it show that item's best day of sales" do
      merchant = Merchant.first
      item1 = Item.find(13)

      visit merchant_items_path(merchant)

      within ".top-items" do
        expect(page.all('p', text: '/').count).to eq(5)
        within "#item-#{item1.id}" do
          expect(page).to have_content("Top day for #{item1.name} was #{item1.invoice_items.top_sales_date.strftime("%m/%d/%Y")}")
        end
      end
    end
  end
end
