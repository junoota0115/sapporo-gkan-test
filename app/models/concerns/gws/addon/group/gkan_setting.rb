module Gws::Addon::Group::GkanSetting
  extend ActiveSupport::Concern
  extend SS::Addon

  included do
    field :code, type: String
    permit_params :code
    validates :code, uniqueness: true, if: -> { code.present? }
  end
end
