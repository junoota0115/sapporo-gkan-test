module Gws::Addon::Gkan
  module LeaveSetting
    module Unit
      extend ActiveSupport::Concern
      extend SS::Addon

      included do
        has_many :units, class_name: "Gws::Gkan::LeaveUnit", dependent: :destroy, inverse_of: :setting
      end
    end
  end
end
