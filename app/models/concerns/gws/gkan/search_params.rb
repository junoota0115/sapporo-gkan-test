module Gws::Gkan::SearchParams
  extend ActiveSupport::Concern
  include SS::PermitParams

  included do
    attr_accessor :cur_site, :cur_user, :encoding
    permit_params :encoding

    alias site cur_site
    alias user cur_user
  end

  public

  def search
    []
  end

  def enum_csv
    Enumerator.new do |y|
      y << bom + encode(headers.to_csv)
    end
  end

  def headers
    ["未実装"]
  end

  private

  def encode(str)
    return str if encoding != "Shift_JIS"
    str.encode("SJIS", invalid: :replace, undef: :replace)
  end

  def bom
    return '' if encoding == 'Shift_JIS'
    SS::Csv::UTF8_BOM
  end

  module ClassMethods
    def t(*args)
      human_attribute_name(*args)
    end

    def tt(key, html_wrap = true)
      modelnames = ancestors.select { |x| x.respond_to?(:model_name) }
      msg = ""
      modelnames.each do |modelname|
        msg = I18n.t("tooltip.#{modelname.model_name.i18n_key}.#{key}", default: "")
        break if msg.present?
      end
      return msg if msg.blank? || !html_wrap
      msg = [msg] if msg.class.to_s == "String"
      list = msg.map { |d| "<li>" + d.to_s.gsub(/\r\n|\n/, "<br />") + "<br /></li>" }

      h = []
      h << %(<div class="tooltip">?)
      h << %(<ul class="tooltip-content">)
      h << list
      h << %(</ul>)
      h << %(</div>)
      h.join("\n").html_safe
    end
  end
end
