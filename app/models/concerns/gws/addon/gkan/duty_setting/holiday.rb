module Gws::Addon::Gkan
  module DutySetting
    module Holiday
      extend ActiveSupport::Concern
      extend SS::Addon

      included do
        %w(sunday monday tuesday wednesday thursday friday saturday national_holiday).each do |wday|
          field "#{wday}_type", type: String, default: default_wday_type(wday)
          permit_params "#{wday}_type"
          validates "#{wday}_type", presence: true, inclusion: { in: %w(workday holiday), allow_blank: true }
        end
      end

      def wday_type_options
        %w(workday holiday).map do |v|
          [ I18n.t("gws/gkan.options.wday_type.#{v}"), v ]
        end
      end

      %w(sunday monday tuesday wednesday thursday friday saturday national_holiday).each do |wday|
        alias_method "#{wday}_type_options", :wday_type_options
      end

      def regular_holiday(date)
        if date.national_holiday?
          return national_holiday_type
        end

        wday = %w(sunday monday tuesday wednesday thursday friday saturday)[date.wday]
        send("#{wday}_type")
      end

      module ClassMethods
        def default_wday_type(wday)
          @@_default_holidays ||= SS.config.gkan.dig("default_duty", "holidays")
          @@_default_holidays.include?(wday) ? "holiday" : "workday"
        end
      end
    end
  end
end
