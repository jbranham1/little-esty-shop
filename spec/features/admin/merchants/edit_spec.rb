require 'rails_helper'

RSpec.describe 'Admin Merchant Edit Page' do
  before :each do
    @merchant = Merchant.third
  end

  describe 'As an Admin,' do
    describe 'When I visit merchant edit page' do
      describe 'I can update a merchant' do
        it 'I am taken to an edit form with the current information pre-populated' do
          visit admin_merchant_path(@merchant.id)
          expect(page).to have_button("Update Merchant")
          click_button "Update Merchant"
          expect(current_path).to eq("/admin/merchants/#{@merchant.id}/edit")

          expect(page).to have_field("name")
          fill_in :name, with: " "
          click_button("submit")
          expect(page).to have_content("Name can't be blank")
        end
      end
    end
  end
end
