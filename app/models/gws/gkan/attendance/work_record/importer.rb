class Gws::Gkan::Attendance::WorkRecord::Importer
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
    true
  end

  def headers
    %w(organization_uid date).map { |v| t(v) }
  end

  class << self
    def t(*args)
      human_attribute_name *args
    end
  end
end
