class Gws::Gkan::Attendance::Leave::MainController < ApplicationController
  include Gws::BaseFilter

  def index
    redirect_to gws_gkan_attendance_leave_files_path(state: "mine")
  end
end
