class HolidayFacade
  def holidays
    Holiday.new(service.holiday_data)
  end

  def service
    HolidayService.new
  end
end
