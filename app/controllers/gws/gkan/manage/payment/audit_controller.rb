class Gws::Gkan::Manage::Payment::AuditController < ApplicationController
  include Gws::BaseFilter
  include Gws::CrudFilter

  model Gws::Gkan::Manage::Payment::SearchAudit

  navi_view "gws/gkan/manage/payment/main/navi"

  before_action :set_leave

  helper_method :leave_options

  private

  def set_crumbs
    @crumbs << [ @cur_site.menu_gkan_attendance_label || t('modules.gws/gkan/attendance'), gws_gkan_attendance_main_path ]
    @crumbs << [ t('modules.gws/gkan/manage/payment'), gws_gkan_manage_payment_main_path ]
    @crumbs << [ t('modules.gws/gkan/manage/payment/audit'), { action: :index } ]
  end

  def set_item
    if params[:item]
      @item = @model.new get_params
    else
      @item = @model.new fix_params
      @item.start = Time.zone.today.beginning_of_month
      @item.close = Time.zone.today.end_of_month
      @item.export_unit = "daily"
    end
  end

  def set_leave
    @leave = Gws::Gkan::Leave.site(@cur_site)
  end

  def leave_options
    @leave.map { |item| [item.long_name, item.id] }
  end

  public

  def index
    set_item
    raise "403" unless @item.allowed?(:use, @cur_user, site: @cur_site)

    if request.get? || request.head?
      return
    end
    send_enum @item.enum_csv, filename: "payment_audit_#{Time.zone.now.to_i}.csv"
  end
end
