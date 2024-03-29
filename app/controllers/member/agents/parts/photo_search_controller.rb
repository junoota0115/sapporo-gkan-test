class Member::Agents::Parts::PhotoSearchController < ApplicationController
  include Cms::PartFilter::View

  def index
    @node = @cur_part.parent
    return head :ok unless @node

    @locations  = Member::Node::PhotoLocation.site(@cur_site).and_public(@cur_date)
    @categories = Member::Node::PhotoCategory.site(@cur_site).and_public(@cur_date)
    @query      = {
      keyword: "",
      contributor: "",
      location_ids: [],
      category_ids: [],
      locations: [],
      categories: []
    }
  end
end
