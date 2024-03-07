class Gws::Gkan::Apis::UsersController < ApplicationController
  include Gws::ApiFilter

  model Gws::Gkan::AttendanceSetting

  helper_method :employee_type_options

  def index
    @multi = params[:single].blank?

    date = Time.zone.now

    stages = []
    stages << { "$match" => @model.and_current(date).selector }
    stages << { "$lookup" => { from: "ss_users", "localField" => "user_id", "foreignField" => "_id", as: "users" } }
    stages << { "$lookup" => { from: "gws_gkan_duty_settings", "localField" => "duty_setting_id", "foreignField" => "_id", as: "duty_settings" } }
    stages << { "$sort" => { organization_uid: 1 } }
    stages << { "$project" => {
      "user" => { "$arrayElemAt" => [ "$users", 0 ] },
      "duty_setting" => { "$arrayElemAt" => [ "$duty_settings", 0 ] },
    } }

    s = params[:s] || {}
    if s[:employee_types].present?
      employee_types = s[:employee_types].select(&:present?)
      stages << { "$match" => { "duty_setting.employee_type" => { "$in" => employee_types } } }
    end
    if s[:keyword].present?
      keyword = s[:keyword]
      stages << { "$match" => { "$or" => [
        { "user.name" => /#{::Regexp.escape(keyword)}/i },
        { "user.organization_uid" => /#{::Regexp.escape(keyword)}/i },
      ] } }
    end

    @items = Gws::Gkan::AttendanceSetting.collection.aggregate(stages).to_a
    @items = Kaminari.paginate_array(@items).page(params[:page]).per(50)
  end

  private

  def employee_type_options
    I18n.t("gws/gkan.options.employee_type").map { |k, v| [v, k] }
  end
end
