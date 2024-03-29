class Cms::PageSearch
  include SS::Document
  include SS::Reference::Site
  include Cms::Addon::PageSearch
  include Cms::Addon::GroupPermission

  attr_accessor :cur_user

  seqid :id
  field :name, type: String
  field :order, type: Integer, default: 0

  permit_params :name, :order

  validates :name, presence: true

  def csv_headers
    %w(id filename basename name layout_id state created updated)
  end

  def to_csv(site, user)
    self.cur_site = site
    self.cur_user = user

    I18n.with_locale(I18n.default_locale) do
      CSV.generate do |data|
        data << csv_headers.map { |k| t k }
        search.each do |item|
          data << csv_line(item)
        end
      end
    end
  end

  def csv_line(item)
    line = []
    line << item.id
    line << item.filename
    line << item.basename
    line << item.name
    line << Cms::Layout.where(_id: item.layout_id).pluck(:name).first
    line << item.label(:state)
    line << I18n.l(item.created, format: :picker)
    line << I18n.l(item.updated, format: :picker)
    line
  end

  def root_owned?(user)
    true
  end

  class << self
    def search(params)
      criteria = self.where({})
      return criteria if params.blank?

      if params[:name].present?
        criteria = criteria.search_text params[:name]
      end
      if params[:keyword].present?
        criteria = criteria.keyword_in params[:keyword], :name, :search_name, :search_filename
      end
      criteria
    end
  end
end
