module Gws::Addon::Gkan
  module AttendanceSetting
    module PaidLeave
      extend ActiveSupport::Concern
      extend SS::Addon

      included do
        has_many :paid_leave, class_name: "Gws::Gkan::PaidLeave", dependent: :destroy
      end
    end
  end
end
