class Sys::GroupsController < ApplicationController
  include Sys::BaseFilter
  include Sys::CrudFilter

  model Sys::Group

  menu_view "sys/crud/menu"

  after_action :reload_nginx, only: [:create, :update, :destroy, :destroy_all]

  private

  def permit_fields
    super + [:upload_policy]
  end

  def set_crumbs
    @crumbs << [t("sys.group"), sys_groups_path]
  end

  def reload_nginx
    if SS.config.ss.updates_and_reloads_nginx_conf
      SS::Nginx::Config.new.write.reload_server
    end
  end

  public

  def index
    raise "403" unless @model.allowed?(:edit, @cur_user)

    @items = @model.allow(:edit, @cur_user).
      state(params.dig(:s, :state)).
      search(params[:s]).
      page(params[:page]).per(50)
  end

  def destroy
    raise "403" unless @item.allowed?(:delete, @cur_user)
    render_destroy @item.disable
  end

  def destroy_all
    disable_all
  end

  def role_edit
    set_item
    return "404" if @item.users.blank?
    render :role_edit
  end

  def role_update
    set_item
    role_ids = params[:item][:sys_role_ids].select(&:present?).map(&:to_i)

    @item.users.each do |user|
      user.set(sys_role_ids: role_ids)
    end
    render_update true
  end

  def download_all
    raise "403" unless @model.allowed?(:edit, @cur_user, site: @cur_site)

    return if request.get? || request.head?

    @item = SS::DownloadParam.new
    @item.attributes = params.require(:item).permit(:encoding)
    if @item.invalid?
      render
      return
    end

    exporter = Sys::GroupExporter.new(criteria: @model.allow(:edit, @cur_user).order_by(_id: 1))
    send_enum exporter.enum_csv(encoding: @item.encoding), filename: "sys_groups_#{Time.zone.now.to_i}.csv"
  end

  def import
    raise "403" unless @model.allowed?(:edit, @cur_user, site: @cur_site)

    return if request.get? || request.head?

    @item = SS::ImportParam.new(cur_site: @cur_site, cur_user: @cur_user)
    @item.attributes = params.require(:item).permit(:in_file)
    if @item.in_file.blank? || ::File.extname(@item.in_file.original_filename).casecmp(".csv") != 0
      @item.errors.add :base, :invalid_csv
      render action: :import
      return
    end

    if !Sys::GroupImportJob.valid_csv?(@item.in_file)
      @item.errors.add :base, :malformed_csv
      render action: :import
      return
    end

    temp_file = SS::TempFile.create_empty!(model: 'ss/temp_file', filename: @item.in_file.original_filename) do |new_file|
      IO.copy_stream(@item.in_file, new_file.path)
    end
    job = Sys::GroupImportJob.bind(site_id: @cur_site, user_id: @cur_user)
    job.perform_later(temp_file.id)
    redirect_to url_for(action: :index), notice: t('ss.notice.started_import')
  end
end
