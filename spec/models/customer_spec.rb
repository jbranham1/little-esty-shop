require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'validations' do
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
  end

  describe 'class methods' do
    describe '::top_customer_by_merchant' do
      it "gets the top 5 customers with successful transactions for a specific merchant" do
      end
    end
  end
end
