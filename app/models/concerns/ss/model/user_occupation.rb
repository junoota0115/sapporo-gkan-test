module SS::Model::UserOccupation
  extend ActiveSupport::Concern
  extend SS::Translation
  include SS::Document
  include SS::Fields::Normalizer
  include SS::Scope::ActivationDate

  included do
    store_in collection: "ss_user_occupations"

    seqid :id
    field :code, type: String
    field :name, type: String
    field :remark, type: String
    field :order, type: Integer, default: 0
    field :activation_date, type: DateTime
    field :expiration_date, type: DateTime

    belongs_to :group, class_name: "SS::Group"

    permit_params :code, :name, :remark, :order, :activation_date, :expiration_date

    validates :code, presence: true, length: { maximum: 40 }
    validates :name, presence: true
    validates :order, presence: true
    validates :group_id, presence: true
    validates :activation_date, datetime: true
    validates :expiration_date, datetime: true

    index({ group_id: 1, order: 1 })
  end

  module ClassMethods
    def search(params)
      all.search_keyword(params)
    end

    def search_keyword(params)
      return all if params.blank? || params[:keyword].blank?
      all.keyword_in params[:keyword], :code, :name, :remark
    end
  end

  def name_with_code
    code.present? ? "#{name} (#{code})" : name
  end
end
