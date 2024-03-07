class Workflow::RoutesController < ApplicationController
  include Cms::BaseFilter
  include Cms::CrudFilter

  model Workflow::Route

  navi_view "cms/main/conf_navi"

  private

  def set_crumbs
    @crumbs << [t("workflow.name"), action: :index]
  end

  def fix_params
    { cur_user: @cur_user, cur_site: @cur_site }
  end


  def set_item
    super
    raise "403" unless @model.site(@cur_site).include?(@item)
  end

  public

  def index
    raise "403" unless @model.allowed?(:use, @cur_user, site: @cur_site)
    @items = @model.user(@cur_user)
  end
end
