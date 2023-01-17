class Holiday 
  attr_reader :date, :name

  def initialize(holiday_params)
    @date = holiday_params["date"]
    @name = holiday_params["localName"]
  end
end