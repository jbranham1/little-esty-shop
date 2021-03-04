class BulkDiscountIndexFacade
  attr_reader :merchant,
              :upcoming_holidays

  def initialize(merchant_id)
    @merchant = Merchant.find(merchant_id)
    @upcoming_holidays = get_holidays
  end

  def get_holidays
    # nager_service = NagerService.new
    # nager_service.get_upcoming_holidays.map do |data|
    #   Holiday.new(data)
    # end
    data= {localName: 'name', date: ''}
    [Holiday.new(data)]
  end
end
