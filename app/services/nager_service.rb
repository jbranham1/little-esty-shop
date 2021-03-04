class NagerService
  def get_upcoming_holidays
    response = Faraday.get("https://date.nager.at/Api/v2/NextPublicHolidays/US")
    data = response.body
    json = JSON.parse(data, symbolize_names: true)[0..2]
  end
end
