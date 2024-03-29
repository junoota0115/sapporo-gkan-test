class Cms::LoginController < ApplicationController
  include Cms::BaseFilter
  include Sns::LoginFilter

  skip_before_action :logged_in?, only: [:login, :remote_login, :status]

  private

  def set_organization
    return if @cur_organization.present?

    organizations = SS::Group.organizations.in(id: @cur_site.root_groups.map(&:id)).where(domains: request_host)
    return if organizations.size != 1

    @cur_organization = SS.current_organization = organizations.first
  end

  def default_logged_in_path
    cms_contents_path(site: @cur_site)
  end

  def get_params
    params.require(:item).permit(:uid, :email, :password, :encryption_type)
  rescue
    raise "400"
  end

  public

  def login
    if !request.post?
      # retrieve parameters from get parameter. this is bookmark support.
      @item = SS::User.new email: params[:email]
      return render(template: "login")
    end

    safe_params     = get_params
    email_or_uid    = safe_params[:email].presence || safe_params[:uid]
    password        = safe_params[:password]
    encryption_type = safe_params[:encryption_type]

    if encryption_type.present?
      password = SS::Crypto.decrypt(password, type: encryption_type) rescue nil
    end

    @item = begin
      if @cur_organization
        SS::User.organization_authenticate(@cur_organization, email_or_uid, password) rescue nil
      else
        SS::User.site_authenticate(@cur_site, email_or_uid, password) rescue nil
      end
    end
    @item = nil if @item && !@item.enabled?
    @item = @item.try_switch_user || @item if @item

    render_login @item, email_or_uid, session: true, password: password, logout_path: cms_logout_path(site: @cur_site)
  end
end
