class Gws::Gkan::Attendance::MainController < ApplicationController
  include Gws::BaseFilter

  def index
    today = @cur_site.calc_attendance_date(Time.zone.now)
    redirect_to gws_gkan_attendance_time_cards_path(year_month: today.strftime('%Y%m'))
  end
end
