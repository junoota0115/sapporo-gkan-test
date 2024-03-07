class Gws::SmartHr::UsersController < ApplicationController
  include Gws::BaseFilter
  include SS::JobFilter

  navi_view "gws/smart_hr/main/navi"

  private

  def set_crumbs
    @crumbs << [t('modules.gws/smart_hr'), gws_smart_hr_main_path]
    @crumbs << [t('modules.gws/smart_hr/users'), action: :index]
  end

  def set_item
    @item = Gws::Task.find_or_create_by name: task_name, site_id: @cur_site.id
  end

  public

  def job_class
    Gws::SmartHr::UserImportJob
  end

  def job_bindings
    { site_id: @cur_site.id }
  end

  def task_name
    job_class.task_name
  end

  def index
    respond_to do |format|
      format.html { render }
      format.json do
        render template: "ss/tasks/index", content_type: json_content_type, locals: { item: @item }
      end
    end
  end
end
