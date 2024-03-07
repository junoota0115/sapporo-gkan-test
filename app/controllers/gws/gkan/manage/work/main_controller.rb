class Gws::Gkan::Manage::Work::MainController < ApplicationController
  include Gws::BaseFilter

  def index
    redirect_to gws_gkan_manage_work_members_path
  end
end
