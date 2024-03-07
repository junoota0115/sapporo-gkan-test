class Gws::Gkan::Attendance::WorkRecord::Downloader
  extend SS::Translation
  include ActiveModel::Model
  include Gws::Gkan::SearchParams

  attr_accessor :start, :close, :user_id
  permit_params :start, :close, :user_id

  def user
    @user ||= Gws::Group.find(user_id) rescue nil
  end
end
