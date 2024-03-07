class Gws::Gkan::Attendance::TimeCard::Downloader
  extend SS::Translation
  include ActiveModel::Model
  include Gws::Gkan::SearchParams

  attr_accessor :item
end
