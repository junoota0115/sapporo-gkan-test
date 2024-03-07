class Gws::Gkan::Attendance::HolidayWork::MainController < ApplicationController
  include Gws::BaseFilter

  def index
    redirect_to gws_gkan_attendance_holiday_work_files_path(state: "mine")
  end
end
