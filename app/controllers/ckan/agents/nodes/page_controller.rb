class Ckan::Agents::Nodes::PageController < ApplicationController
  include Cms::NodeFilter::View

  def rss
    rss = RSS::Maker.make("2.0") do |rss|
      rss.channel.title       = "#{@cur_node.name} - #{@cur_node.site.name}"
      rss.channel.link        = @cur_node.full_url
      rss.channel.description = "CKAN News"
      rss.channel.about       = @cur_node.full_url
      rss.channel.language    = "ja"

      @cur_node.values.each do |value|
        date = value['metadata_modified']
        rss.items.new_item do |entry|
          entry.title       = value['title'] || value['name']
          entry.link        = "#{@cur_node.ckan_item_url}/#{value['name']}"
          entry.description = nil
          entry.pubDate     = date.to_s
        end
      end
    end

    render xml: rss.to_xml, content_type: "application/xml"
  end
end
