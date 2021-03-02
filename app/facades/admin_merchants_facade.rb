class AdminMerchantsFacade
  attr_reader :merchants,
              :top_merchants

  def initialize
    @merchants = Merchant.all
    @top_merchants = Merchant.top_5_by_revenue
  end
end
