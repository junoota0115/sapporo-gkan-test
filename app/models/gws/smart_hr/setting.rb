module Gws::SmartHr
  class Setting
    include ActiveModel::Model

    def url
      "https://sample.example.jp"
    end

    def api_key
      "xxxxxxxxxxxxxxxxxxxxxxxxx"
    end

    def t(name, opts = {})
      self.class.t name, opts
    end

    class << self
      def t(*args)
        human_attribute_name(*args)
      end
    end
  end
end
