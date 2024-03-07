class Gws::Gkan::Attendance::OvertimeFileEdit
  extend SS::Translation
  include ActiveModel::Model
  include SS::PermitParams

  attr_accessor :items, :in_items

  permit_params in_items: [:id, :in_date, :in_start_hour, :in_start_minute, :in_close_hour, :in_close_minute]

  validate :validate_items

  def save
    return false if invalid?
    items.each(&:save)
  end

  private

  def validate_items
    errors.add :items, :blank if items.blank?
    errors.add :in_items, :blank if in_items.blank?
    return if errors.present?

    in_items.each do |in_item|
      item = items.find { |item| item.id.to_s == in_item["id"] }
      next if item.nil?

      item.attributes = in_item.except("id")
      next if item.valid?
      SS::Model.copy_errors(item, self)
    end
  end

  class << self
    def t(*args)
      human_attribute_name(*args)
    end
  end
end
