class Gws::Gkan::Attendance::DefaultRecord::Importer
  extend SS::Translation
  include ActiveModel::Model
  include SS::PermitParams

  attr_accessor :cur_site, :cur_user, :in_file
  permit_params :cur_site, :cur_user, :in_file

  validates :site, presence: true
  validates :user, presence: true
  validate :validate_in_file

  alias site cur_site
  alias user cur_user

  def import
    return false if invalid?
    SS::Csv.foreach_row(in_file, headers: true) do |row, i|
      update_row(row, i + 2)
    end
    errors.blank?
  end

  def template_csv
    csv = CSV.generate do |data|
      data << headers
    end
    csv = "\uFEFF" + csv
    csv.encode("UTF-8", invalid: :replace, undef: :replace)
  end

  def t(name, opts = {})
    self.class.t name, opts
  end

  private

  def validate_in_file
    if in_file.nil?
      self.errors.add :in_file, :blank
      return
    end
    if !SS::Csv.valid_csv?(in_file, headers: true)
      self.errors.add :base, :invalid_csv
    end
  end

  def update_row(row, idx)
    organization_uid = row[t(:organization_uid)].to_s.strip
    date = row[t(:date)].to_s.strip
    start = row[t(:start)].to_s.strip
    close = row[t(:close)].to_s.strip
    regular_start = row[t(:regular_start)].to_s.strip
    regular_close = row[t(:regular_close)].to_s.strip
    break_time = row[t(:break_time)].to_s.strip
    night_shift = row[t(:night_shift)].to_s.strip
    regular_holiday = row[t(:regular_holiday)].to_s.strip

    target = Gws::User.active.site(site).find_by(organization_uid: organization_uid) rescue nil
    date = Time.zone.parse(date).to_date rescue nil
    start = str_to_time(start, date)
    close = str_to_time(close, date)
    break_time = str_to_time(break_time, date)
    regular_start = str_to_time(regular_start, date)
    regular_close = str_to_time(regular_close, date)

    if target.nil?
      self.errors.add :base, "#{idx}行目: ユーザーが見つかりません。(#{organization_uid})"
      return false
    end
    #if date.nil? || start.nil? || regular_start.nil? ||  regular_close.nil? || close.nil? || break_time.nil?
    #  self.errors.add :base, "#{idx}行目: 年月日あるいは時間が正しく入力されていません。"
    #  return false
    #end

    month = date.beginning_of_month.to_date
    time_card = find_or_create_time_card(target, month)
    if time_card.errors.present?
      self.errors.add :base, "#{idx}行目: タイムカードの作成に失敗しました。(#{time_card.errors.full_messages.join(",")})"
      return false
    end

    regular_holiday_h = I18n.t("gws/gkan.options.regular_holiday").invert
    night_shift_h = I18n.t("gws/gkan.options.night_shift").invert

    record = time_card.records.where(date: date).first_or_create
    record.start = start
    record.close = close
    record.regular_start = regular_start
    record.regular_close = regular_close
    record.break_time = break_time
    record.night_shift = night_shift_h[night_shift]
    record.regular_holiday = regular_holiday_h[regular_holiday]

    if !record.save
      self.errors.add :base, "#{idx}行目: 日時の更新に失敗しました。(#{record.errors.full_messages.join(",")})"
      return false
    end
    true
  end

  def find_or_create_time_card(target, month)
    @time_cards ||= {}
    @time_cards[target.id] ||= {}
    @time_cards[target.id][month] ||= Gws::Gkan::Attendance::TimeCard.site(site).user(target).where(date: month).first

    time_card = @time_cards[target.id][month]
    return time_card if time_card

    @attendances ||= {}
    @attendances[target.id] ||= {}
    @attendances[target.id][month] = Gws::Gkan::AttendanceSetting.current_setting(site, target, month)
    attendance = @attendances[target.id][month]

    # create_new_time_card_if_necessary
    time_card = Gws::Gkan::Attendance::TimeCard.new
    time_card.cur_site = site
    time_card.cur_user = target
    time_card.duty_setting = attendance.duty_setting if attendance
    time_card.date = month
    time_card.save

    @time_cards[target.id][month] = time_card
    time_card
  end

  def str_to_time(str, date)
    return nil if str.blank? || date.blank?

    str = "0:#{str}" if !str.index(":")
    return nil if str !~ /^\d\d?:?\d\d?$/

    begin
      time = Time.zone.parse(str)
      time.change(year: date.year, month: date.month, day: date.day)
    rescue
      nil
    end
  end

  def headers
    %w(organization_uid date regular_start regular_close start close break_time night_shift regular_holiday).map { |v| t(v) }
  end

  class << self
    def t(*args)
      human_attribute_name *args
    end
  end
end
