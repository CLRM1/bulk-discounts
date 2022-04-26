class HolidayController < ApplicationController
  def show
    @holidays = HolidayFacade.new.holidays
  end
end
