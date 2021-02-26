require 'rails_helper'

RSpec.describe Merchant, type: :model do

  describe 'relationships' do
    it {should have_many :items}
    it {should have_many(:invoice_items).through(:items)}
    it {should have_many(:invoices).through(:invoice_items)}
    it {should have_many(:transactions).through(:invoices)}
    it {should have_many(:customers).through(:invoices)}
  end

  describe 'validations' do
    it {should validate_presence_of :name}
  end

  it 'is created with status enabled when not provided' do
    cool = Merchant.create!(name: "Cool Beans")

    expect(cool.status).to eq("enabled")
    expect(cool.enabled?).to eq(true)
    expect(cool.disabled?).to eq(false)
  end

  it 'can have status disabled' do
    cool = Merchant.create!(name: "Cool Beans")
    cool.update!(status: :disabled)

    expect(cool.status).to eq("disabled")
    expect(cool.enabled?).to eq(false)
    expect(cool.disabled?).to eq(true)
  end
end
