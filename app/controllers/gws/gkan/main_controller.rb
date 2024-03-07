class Gws::Gkan::MainController < ApplicationController
  include Gws::BaseFilter

  def index
    redirect_to gws_gkan_attendance_main_path
  end
end
