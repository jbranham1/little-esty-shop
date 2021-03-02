require 'rails_helper'

RSpec.describe 'Welcome Page' do
  describe "As a user," do
    describe "When I visit my welcome page" do
      it "I see a link to merchants and admin" do
        visit '/'
        expect(current_path).to eq("/")
        expect(page).to have_content("Welcome to our Little Esty Shop")
      end
    end
  end
end
