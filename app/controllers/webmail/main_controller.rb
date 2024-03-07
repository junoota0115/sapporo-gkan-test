class Webmail::MainController < ApplicationController
  include Webmail::BaseFilter

  def index
    redirect_to webmail_mails_path(webmail_mode: @webmail_mode, account: params[:account] || @cur_user.imap_default_index)
  end
end
