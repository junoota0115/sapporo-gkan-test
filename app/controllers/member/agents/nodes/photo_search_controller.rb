class Member::Agents::Nodes::PhotoSearchController < ApplicationController
  include Cms::NodeFilter::View

  model Member::Photo

  helper Member::PhotoHelper

  before_action :set_query

  private

  def set_query
    @locations  = Member::Node::PhotoLocation.site(@cur_site).and_public(@cur_date)
    @categories = Member::Node::PhotoCategory.site(@cur_site).and_public(@cur_date)
    @query      = query
  end

  def query
    location_ids = params[:location_ids].select(&:present?).map(&:to_i) rescue []
    category_ids = params[:category_ids].select(&:present?).map(&:to_i) rescue []
    locations    = @locations.in(id: location_ids)
    categories   = @categories.in(id: category_ids)
    {
      keyword: params[:keyword],
      contributor: params[:contributor],
      location_ids: location_ids,
      category_ids: category_ids,
      locations: locations,
      categories: categories,
    }
  end

  public

  def index
    @items = @model.site(@cur_site).and_public(@cur_date).
      where(@cur_node.condition_hash).
      listable.
      contents_search(@query).
      order_by(@cur_node.sort_hash).
      page(params[:page]).
      per(@cur_node.limit)

    render_with_pagination @items
  end

  def map
    @items = @model.site(@cur_site).and_public(@cur_date).
      where(@cur_node.condition_hash).
      listable.
      where(:map_points.exists => true).
      contents_search(@query).
      order_by(@cur_node.sort_hash).
      page(params[:page]).
      per(@cur_node.limit)

    @markers = @items.map { |item| item.map_points }.flatten

    render_with_pagination @items
  end
end
