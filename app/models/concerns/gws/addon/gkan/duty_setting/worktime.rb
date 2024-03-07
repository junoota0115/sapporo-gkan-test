module Gws::Addon::Gkan
  module DutySetting
    module Worktime
      extend ActiveSupport::Concern
      extend SS::Addon

      included do
        # 所定労働時間(日)
        attr_accessor :in_worktime_day_hour, :in_worktime_day_minute
        field :worktime_day_minute, type: Integer
        permit_params :in_worktime_day_hour, :in_worktime_day_minute
        before_validation :set_worktime_day_minute
        validates :worktime_day_minute, presence: true, numericality: { greater_than: 0 }

        # 所定労働時間(週)
        attr_accessor :in_worktime_week_hour, :in_worktime_week_minute
        field :worktime_week_minute, type: Integer
        permit_params :in_worktime_week_hour, :in_worktime_week_minute
        before_validation :set_worktime_week_minute
        validates :worktime_week_minute, presence: true, numericality: { greater_than: 0 }

        # 所定労働時間(勤務)
        field :worktime_of_wday, default: "constant"
        permit_params :worktime_of_wday

        field :start_at_hour, type: Integer, default: SS.config.gkan.dig("default_duty", "worktime", "start_hours")
        field :start_at_minute, type: Integer, default: SS.config.gkan.dig("default_duty", "worktime", "start_minutes")
        field :close_at_hour, type: Integer, default: SS.config.gkan.dig("default_duty", "worktime", "close_hours")
        field :close_at_minute, type: Integer, default: SS.config.gkan.dig("default_duty", "worktime", "close_minutes")
        permit_params :start_at_hour, :start_at_minute
        permit_params :close_at_hour, :close_at_minute

        validates :start_at_hour, presence: true,
          numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 23 }
        validates :start_at_minute, presence: true,
          numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 59 }
        validates :close_at_hour, presence: true,
          numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 23 }
        validates :close_at_minute, presence: true,
          numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 59 }

        (0..6).each do |wday|
          field "start_at_hour_#{wday}", type: Integer, default: SS.config.gkan.dig("default_duty", "worktime", "start_hours")
          field "start_at_minute_#{wday}", type: Integer, default: SS.config.gkan.dig("default_duty", "worktime", "start_minutes")
          field "close_at_hour_#{wday}", type: Integer, default: SS.config.gkan.dig("default_duty", "worktime", "close_hours")
          field "close_at_minute_#{wday}", type: Integer, default: SS.config.gkan.dig("default_duty", "worktime", "close_minutes")
          permit_params "start_at_hour_#{wday}", "start_at_minute_#{wday}"
          permit_params "close_at_hour_#{wday}", "close_at_minute_#{wday}"

          validates "start_at_hour_#{wday}", presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 23 }
          validates "start_at_minute_#{wday}", presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 59 }
          validates "close_at_hour_#{wday}", presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 23 }
          validates "close_at_minute_#{wday}", presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 59 }
        end
      end

      def format_minutes(minutes)
        (minutes.to_i > 0) ? "#{minutes / 60}:#{format("%02d", (minutes % 60))}" : "--:--"
      end

      def long_name
        "#{name} (#{format_minutes(worktime_week_minute)})"
      end

      def worktime_constant?
        worktime_of_wday == "constant"
      end

      def worktime_variable?
        !worktime_constant?
      end

      def hour_options
        (0..23).map do |h|
          [ I18n.t('gws/attendance.hour', count: h), h.to_s ]
        end
      end

      def minute_options
        0.step(59, 5).map do |m|
          [ I18n.t('gws/attendance.minute', count: m), m.to_s ]
        end
      end

      def load_in_minutes
        if worktime_day_minute
          self.in_worktime_day_hour = worktime_day_minute / 60
          self.in_worktime_day_minute = worktime_day_minute % 60
        end
        if worktime_week_minute
          self.in_worktime_week_hour = worktime_week_minute / 60
          self.in_worktime_week_minute = worktime_week_minute % 60
        end
      end

      def set_worktime_day_minute
        return if in_worktime_day_hour.nil? || in_worktime_day_minute.nil?
        self.worktime_day_minute = (in_worktime_day_hour.to_i * 60) + in_worktime_day_minute.to_i
      end

      def set_worktime_week_minute
        return if in_worktime_week_hour.nil? || in_worktime_week_minute.nil?
        self.worktime_week_minute = (in_worktime_week_hour.to_i * 60) + in_worktime_week_minute.to_i
      end

      alias_method "worktime_day_hour_options", "hour_options"
      alias_method "worktime_day_minute_options", "minute_options"
      #alias_method "worktime_week_hour_options", "hour_options"
      def worktime_week_hour_options
        (0..167).map do |h|
          [ I18n.t('gws/attendance.hour', count: h), h.to_s ]
        end
      end
      alias_method "worktime_week_minute_options", "minute_options"

      alias_method "start_at_hour_options", "hour_options"
      alias_method "start_at_minute_options", "minute_options"
      alias_method "close_at_hour_options", "hour_options"
      alias_method "close_at_minute_options", "minute_options"

      alias_method "break_start_at_hour_options", "hour_options"
      alias_method "break_start_at_minute_options", "minute_options"
      alias_method "break_close_at_hour_options", "hour_options"
      alias_method "break_close_at_minute_options", "minute_options"

      (0..6).each do |wday|
        alias_method "start_at_hour_#{wday}_options", "hour_options"
        alias_method "start_at_minute_#{wday}_options", "minute_options"
        alias_method "close_at_hour_#{wday}_options", "hour_options"
        alias_method "close_at_minute_#{wday}_options", "minute_options"
      end

      def start_at_hour(time = nil)
        return super() unless time
        worktime_constant? ? start_at_hour : send("start_at_hour_#{time.wday}")
      end

      def start_at_minute(time = nil)
        return super() unless time
        worktime_constant? ? start_at_minute : send("start_at_minute_#{time.wday}")
      end

      def close_at_hour(time = nil)
        return super() unless time
        worktime_constant? ? close_at_hour : send("close_at_hour_#{time.wday}")
      end

      def close_at_minute(time = nil)
        return super() unless time
        worktime_constant? ? close_at_minute : send("close_at_minute_#{time.wday}")
      end

      def start_time(time = nil)
        hour = start_at_hour(time)
        min = start_at_minute(time)
        time.change(hour: hour, min: min, sec: 0)
      end

      def close_time(time = nil)
        hour = close_at_hour(time)
        min = close_at_minute(time)
        time.change(hour: hour, min: min, sec: 0)
      end

=begin
        def start_at_hour(time = nil)
          return super() unless time
          time_wday? ? send("start_at_hour_#{time.wday}") : start_at_hour
        end

        def start_at_minute(time = nil)
          return super() unless time
          time_wday? ? send("start_at_minute_#{time.wday}") : start_at_minute
        end

        def close_at_hour(time = nil)
          return super() unless time
          time_wday? ? send("close_at_hour_#{time.wday}") : close_at_hour
        end

        def close_at_minute(time = nil)
          return super() unless time
          time_wday? ? send("close_at_minute_#{time.wday}") : close_at_minute
        end

        def break_start_at_hour(time = nil)
          return super() unless time
          time_wday? ? send("break_start_at_hour_#{time.wday}") : break_start_at_hour
        end

        def break_start_at_minute(time = nil)
          return super() unless time
          time_wday? ? send("break_start_at_minute_#{time.wday}") : break_start_at_minute
        end

        def break_close_at_hour(time = nil)
          return super() unless time
          time_wday? ? send("break_close_at_hour_#{time.wday}") : break_close_at_hour
        end

        def break_close_at_minute(time = nil)
          return super() unless time
          time_wday? ? send("break_close_at_minute_#{time.wday}") : break_close_at_minute
        end


        def start(time)
          hour = start_at_hour(time)
          min = start_at_minute(time)
          time.change(hour: hour, min: min, sec: 0)
        end

        def end(time)
          hour = close_at_hour(time)
          min = close_at_minute(time)
          time.change(hour: hour, min: min, sec: 0)
        end

        def break_start(time)
          hour = break_start_at_hour(time)
          min = break_start_at_minute(time)
          time.change(hour: hour, min: min, sec: 0)
        end

        def break_end(time)
          hour = break_close_at_hour(time)
          min = break_close_at_minute(time)
          time.change(hour: hour, min: min, sec: 0)
        end

        def next_changed(time)
          hour = attendance_time_changed_minute / 60
          changed = time.change(hour: hour, min: 0, sec: 0)
          (time > changed) ? changed.advance(days: 1) : changed
        end

        def night_time_start(time)
          hour = SS.config.gws.affair.dig("overtime", "night_time", "start_hour")
          time.change(hour: 0, min: 0, sec: 0)
          time.advance(hours: hour)
        end

        def night_time_end(time)
          hour = SS.config.gws.affair.dig("overtime", "night_time", "close_hour")
          time.change(hour: 0, min: 0, sec: 0)
          time.advance(hours: hour)
        end

        def working_minute(time, enter = nil, leave = nil)
          start_at = start(time)
          close_at = end(time)

          if enter
            start_at = enter > start_at ? enter : start_at
          end
          if leave
            close_at = leave > close_at ? close_at : leave
          end

          break_start_at = break_start(time)
          break_close_at = break_end(time)

          minutes, = Gws::Affair::Utils.time_range_minutes(start_at..close_at, break_start_at..break_close_at)
          minutes
        end
=end
    end
  end
end
