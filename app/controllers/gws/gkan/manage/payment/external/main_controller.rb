class Gws::Gkan::Manage::Payment::External::MainController < ApplicationController
  include Gws::BaseFilter

  def index
    redirect_to gws_gkan_manage_payment_external_regular21g_path
  end
end
