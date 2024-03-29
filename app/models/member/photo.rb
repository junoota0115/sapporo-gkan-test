class Member::Photo
  include Cms::Model::Page
  include Cms::Addon::MemberReference
  include Workflow::Addon::Approver
  include Member::Addon::Photo::Body
  include Member::Addon::Photo::Category
  include Member::Addon::Photo::Location
  include Member::Addon::Photo::Map
  include Member::Addon::Photo::License
  include Cms::Addon::GroupPermission
  include History::Addon::Backup
  include Cms::Lgwan::Page

  set_permission_name "member_photos"

  before_save :seq_filename, if: ->{ basename.blank? }

  default_scope ->{ where(route: "member/photo") }
  validate :center_position_validate, if: -> { set_center_position.present? }
  validate :zoom_level_validate, if: -> { set_zoom_level.present? }

  field :listable_state, type: String, default: "public"
  field :slideable_state, type: String, default: "closed"

  field :slide_order, type: Integer, default: 0

  permit_params :listable_state, :slideable_state, :slide_order

  def listable_state_options
    [
      [I18n.t('ss.options.state.public'), 'public'],
      [I18n.t('ss.options.state.closed'), 'closed'],
    ]
  end

  def slideable_state_options
    [
      [I18n.t('ss.options.state.public'), 'public'],
      [I18n.t('ss.options.state.closed'), 'closed'],
    ]
  end

  def slide_order
    value = self[:slide_order].to_i
    value < 0 ? 0 : value
  end

  def file_previewable?(file, site:, user:, member:)
    return true if super

    return true if member.present? && member_id == member.id

    false
  end

  def slideable?
    slideable_state == "public"
  end

  private

  def validate_filename
    (@basename && @basename.blank?) ? nil : super
  end

  def seq_filename
    self.filename = dirname ? "#{dirname}#{id}.html" : "#{id}.html"
  end

  def center_position_validate
    lonlat = set_center_position.split(',')
    if lonlat.length == 2
      lat = lonlat[1]
      lon = lonlat[0]
      if !lat.numeric? || !lon.numeric?
        self.errors.add :set_center_position, :invalid_latlon
      elsif lat.to_f.floor < -90 || lat.to_f.ceil > 90 || lon.to_f.floor < -180 || lon.to_f.ceil > 180
        self.errors.add :set_center_position, :invalid_latlon
      end
    else
      self.errors.add :set_center_position, :invalid_latlon
    end
  end

  def zoom_level_validate
    if set_zoom_level <= 0 || set_zoom_level > 21
      self.errors.add :set_zoom_level, :invalid_zoom_level
    end
  end

  class << self
    def contents_search(params = {})
      criteria = self.where({})
      return criteria if params.blank?

      if params[:keyword].present?
        criteria = criteria.search_text(params[:keyword])
      end

      if params[:contributor].present?
        member_ids = Cms::Member.search_text(params[:contributor]).map(&:id)
        criteria = criteria.in(member_id: member_ids)
      end

      if params[:location_ids].present?
        criteria = criteria.in(photo_location_ids: params[:location_ids].select(&:numeric?).map(&:to_i))
      end

      if params[:category_ids].present?
        criteria = criteria.in(photo_category_ids: params[:category_ids].select(&:numeric?).map(&:to_i))
      end

      criteria
    end

    def listable
      where listable_state: "public"
    end

    def slideable
      where slideable_state: "public"
    end
  end
end
