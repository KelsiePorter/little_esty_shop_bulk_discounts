require_relative '../poros/holiday.rb'

class USHolidayService 
  include HTTParty

  def get_next_public_holidays(num_of_holidays = 3)
    response = HTTParty.get('https://date.nager.at/api/v3/NextPublicHolidays/US')
    response[0...num_of_holidays].map do |holiday|
      Holiday.new(holiday)
    end
  end
end