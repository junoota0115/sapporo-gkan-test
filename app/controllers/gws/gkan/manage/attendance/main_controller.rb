class Gws::Gkan::Manage::Attendance::MainController < ApplicationController
  include Gws::BaseFilter

  def index
    redirect_to gws_gkan_manage_attendance_time_cards_path
  end
end
