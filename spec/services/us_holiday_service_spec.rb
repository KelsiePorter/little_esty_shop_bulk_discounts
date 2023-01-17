require 'rails_helper'

RSpec.describe USHolidayService do 
  describe 'get_next_holidays' do 
    it 'should return the specified number of Holiday objects' do 
      WebMock.stub_request(:any, "https://date.nager.at/api/v3/NextPublicHolidays/US").
      to_return(
        body:
          '[
            {"date": "2023-01-16", "localName": "Martin Luther King, Jr. Day"},
            {"date": "2023-02-20", "localName": "Presidents Day"},
            {"date": "2023-04-07", "localName": "Good Friday"}
          ]',
        headers: {content_type: 'application/json'}
      )

      service = USHolidayService.new 
      response = service.get_next_public_holidays

      expect(response.size).to eq(3)

      response.each do |holiday|
        expect(holiday).to be_a(Holiday)
        expect(holiday.name).to_not be nil
        expect(holiday.date).to_not be nil
      end

      WebMock.stub_request(:any, "https://date.nager.at/api/v3/NextPublicHolidays/US").
      to_return(
        body:
          '[
            {"date": "2023-01-16", "localName": "Martin Luther King, Jr. Day"},
            {"date": "2023-02-20", "localName": "Presidents Day"},
            {"date": "2023-04-07", "localName": "Good Friday"},
            {"date": "2023-04-15", "localName": "Fake Holiday 1"},
            {"date": "2023-04-08", "localName": "Fake Holiday 2"}
          ]',
        headers: {content_type: 'application/json'}
      )

      response = service.get_next_public_holidays(5)

      expect(response.size).to eq(5)

      response.each do |holiday|
        expect(holiday).to be_a(Holiday)
        expect(holiday.name).to_not be nil
        expect(holiday.date).to_not be nil
      end
    end
  end
end