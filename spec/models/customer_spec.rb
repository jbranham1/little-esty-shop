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
  describe 'instance methods' do
    describe '::full_name' do
      it "combines first and last name" do
        customer = create(:customer)
        expect(customer.full_name).to eq("#{customer.first_name} #{customer.last_name}")
      end
    end
  end
end
