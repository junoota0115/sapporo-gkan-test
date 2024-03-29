class Cms::ThemeTemplate
  extend SS::Translation
  include SS::Document
  include SS::Reference::Site
  include Cms::SitePermission
  include Cms::Addon::HighContrastMode

  set_permission_name "cms_tools", :use

  seqid :id
  field :name, type: String
  field :class_name, type: String
  field :css_path, type: String
  field :order, type: Integer
  field :state, type: String, default: "public"
  field :default_theme, type: String, default: 'disabled'
  permit_params :name, :class_name, :order, :css_path, :state, :default_theme

  validates :name, presence: true, length: { maximum: 40 }
  validates :class_name, presence: true, uniqueness: { scope: :site_id }

  after_save :check_default, if: ->{ default? }

  default_scope -> { order_by(order: 1, name: 1) }
  scope :and_public, ->(_date = nil){ where state: "public" }

  def state_options
    [
      [I18n.t("ss.options.state.public"), "public"],
      [I18n.t("ss.options.state.closed"), "closed"],
    ]
  end

  def default_theme_options
    %w(enabled disabled).map { |m| [I18n.t("ss.options.state.#{m}"), m] }
  end

  def default?
    default_theme == 'enabled'
  end

  private

  def check_default
    self.class.
        where(default_theme: 'enabled').
        where(:id.ne => id).
        update_all(default_theme: 'disabled')
  end

  class << self
    def search(params = {})
      criteria = self.where({})
      return criteria if params.blank?

      if params[:name].present?
        criteria = criteria.search_text params[:name]
      end
      if params[:keyword].present?
        criteria = criteria.keyword_in params[:keyword], :name
      end
      criteria
    end

    def template(site)
      self.and_public.site(site).map do |item|
        "<a href=\"#\" class=\"#{item.class_name}\">#{item.name}</a>"
      end.join
    end

    def to_config(opts = {})
      h = {}
      h[:theme] = {}

      criteria = self.and_public
      criteria = criteria.site(opts[:site]) if opts[:site]
      criteria.each do |item|
        h[:theme][item.class_name] = {}
        h[:theme][item.class_name]["css_path"] = replace_with_preview_path(item.css_path, opts)
        h[:theme][item.class_name]["name"] = item.name

        if item.default_theme == 'enabled'
          h[:theme][item.class_name]["default_theme"] = true
        end

        if item.high_contrast_mode_enabled?
          h[:theme][item.class_name]["font_color"] = item.font_color
          h[:theme][item.class_name]["background_color"] = item.background_color
        else
          h[:theme][item.class_name]["font_color"] = nil
          h[:theme][item.class_name]["background_color"] = nil
        end
      end

      h
    end

    def replace_with_preview_path(path, opts = {})
      return path unless path.present?
      return path unless opts[:preview_path]
      return path unless opts[:site]
      return path unless path =~ /^\/(?!\/)/

      preview_path = Rails.application.routes.url_helpers.cms_preview_path(site: opts[:site].id)
      ::File.join(preview_path, path)
    end
  end
end
