class Gws::Gkan::Admin::MainController < ApplicationController
  include Gws::BaseFilter

  def index
    redirect_to gws_gkan_admin_users_path
  end
end
