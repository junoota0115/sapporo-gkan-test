module Member::LoginFilter
  extend ActiveSupport::Concern
  include Member::AuthFilter

  REDIRECT_OPTION_UNDEFINED = 0
  REDIRECT_OPTION_ENABLED = 1
  REDIRECT_OPTION_DISABLED = 2

  included do
    before_action :logged_in?, if: -> { member_login_path }
  end

  private

  def logged_in?(opts = {})
    if @cur_member
      set_last_logged_in
      return @cur_member
    end

    @cur_member = get_member_by_session rescue nil

    if @cur_member
      set_last_logged_in
      return @cur_member
    end

    clear_member
    return nil if translate_redirect_option(opts) == REDIRECT_OPTION_DISABLED

    ref = "?ref=#{CGI.escape(request.env["REQUEST_URI"])}" if request.env["REQUEST_URI"].present?
    redirect_to "#{member_login_path}#{ref}"
    nil
  end

  def set_member(member, timestamp = Time.zone.now.to_i)
    if @cur_site
      reset_session if SS.config.sns.logged_in_reset_session
      form_authenticity_token
      session[session_member_key] = {
        "member_id" => member.id,
        "remote_addr" => remote_addr,
        "user_agent" => request.user_agent,
        "last_logged_in" => timestamp
      }
    end
    @cur_member = member
  end

  def set_last_logged_in(timestamp = Time.zone.now.to_i)
    return if !@cur_site
    session[session_member_key]["last_logged_in"] = timestamp if session[session_member_key]
  end

  def clear_member
    session[session_member_key] = nil if @cur_site
    @cur_member = nil
  end

  def member_login_node
    @member_login_node ||= begin
      node = Member::Node::Login.site(@cur_site).and_public.first
      node.presence || false
    end
  end

  def member_login_path
    return false unless member_login_node
    "#{member_login_node.url}login.html"
  end

  def translate_redirect_option(opts)
    case opts[:redirect]
    when true
      REDIRECT_OPTION_ENABLED
    when false
      REDIRECT_OPTION_DISABLED
    else
      REDIRECT_OPTION_UNDEFINED
    end
  end
end
