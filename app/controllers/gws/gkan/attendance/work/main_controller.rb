class Gws::Gkan::Attendance::Work::MainController < ApplicationController
  include Gws::BaseFilter

  def index
    redirect_to gws_gkan_attendance_work_work_days_path
  end
end
