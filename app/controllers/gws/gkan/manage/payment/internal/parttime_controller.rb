class Gws::Gkan::Manage::Payment::Internal::ParttimeController < ApplicationController
  include Gws::BaseFilter
  include Gws::CrudFilter

  model Gws::Gkan::Manage::Payment::Internal::SearchParttime

  navi_view "gws/gkan/manage/payment/main/navi"

  helper_method :fiscal_year_options
  helper_method :month_options

  before_action :set_active_year_range

  private

  def set_crumbs
    @crumbs << [ @cur_site.menu_gkan_attendance_label || t('modules.gws/gkan/attendance'), gws_gkan_attendance_main_path ]
    @crumbs << [ t('modules.gws/gkan/manage/payment'), gws_gkan_manage_payment_main_path ]
    @crumbs << [ t('modules.gws/gkan/manage/payment/internal/overtime'), { action: :index } ]
  end

  def set_active_year_range
    current = @cur_site.fiscal_year
    lower = current - @cur_site.attendance_management_year
    upper = current + @cur_site.attendance_management_year
    @active_year_range = (lower..upper)
  end

  def fiscal_year_options
    @active_year_range.map { |y| ["#{y}#{I18n.t("ss.fiscal_year")}", y] }.reverse
  end

  def month_options
    @cur_site.fiscal_months.map { |m| ["#{m}#{I18n.t('datetime.prompts.month')}", m] }.reverse
  end

  def set_item
    if params[:item]
      @item = @model.new get_params
    else
      @item = @model.new fix_params
      @item.group_id = @cur_group.try(:id) || @cur_site.id
      @item.fiscal_year = @cur_site.fiscal_year
      @item.month = Time.zone.today.month
    end
  end

  public

  def index
    set_item
    raise "403" unless @item.allowed?(:use, @cur_user, site: @cur_site)

    if request.get? || request.head?
      return
    end
    send_enum @item.enum_csv, filename: "payment_internal_parttime_#{Time.zone.now.to_i}.csv"
  end
end
