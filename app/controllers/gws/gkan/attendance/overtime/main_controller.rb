class Gws::Gkan::Attendance::Overtime::MainController < ApplicationController
  include Gws::BaseFilter

  def index
    redirect_to gws_gkan_attendance_overtime_files_path(state: "mine")
  end
end
