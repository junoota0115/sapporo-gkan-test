require 'spec_helper'

describe "opendata_agents_nodes_dataset", type: :feature, dbscope: :example do
  let(:site) { cms_site }
  let(:layout) { create_cms_layout }
  let(:area) { create :opendata_node_area, layout: layout, filename: "opendata_area_1" }
  let(:node_dataset) { create :opendata_node_dataset, layout: layout }
  let(:node_area) { create :opendata_node_area, layout: layout }
  let!(:node_search_dataset) { create :opendata_node_search_dataset, layout: layout, filename: "dataset/search" }
  let!(:page_dataset) { create(:opendata_dataset, cur_node: node_dataset, layout: layout, area_ids: [ node_area.id ]) }
  let!(:node_dataset_category) { create :opendata_node_dataset_category, layout: layout }
  let(:dataset_resource_file_path) { Rails.root.join("spec", "fixtures", "opendata", "shift_jis.csv") }
  let!(:license) { create(:opendata_license, cur_site: site) }
  let(:index_path) { "#{node_dataset.url}index.html" }
  let(:rss_path) { "#{node_dataset.url}rss.xml" }
  let(:areas_path) { "#{node_dataset.url}areas.html" }
  let(:tags_path) { "#{node_dataset.url}tags.html" }
  let(:formats_path) { "#{node_dataset.url}formats.html" }
  let(:licenses_path) { "#{node_dataset.url}licenses.html" }

  let(:show_point_path) { page_dataset.point_url }
  let(:point_members_path) { page_dataset.point_members_url }
  let(:dataset_apps_path) { page_dataset.dataset_apps_url }
  let(:dataset_ideas_path) { page_dataset.dataset_ideas_url }

  let(:datasets_search_path) { "#{node_dataset.url}datasets/search" }

  before do
    dataset_resource = page_dataset.resources.new

    file = Fs::UploadedFile.create_from_file(dataset_resource_file_path, basename: "spec")
    file.original_filename = "shift_jis.csv"

    dataset_resource.in_file = file
    dataset_resource.license = license
    dataset_resource.name = "shift_jis.csv"
    dataset_resource.save!

    Fs.rm_rf page_dataset.path
  end

  it "index, preview" do
    page.driver.browser.with_session("public") do |session|
      session.env("HTTP_X_FORWARDED_HOST", site.domain)
      visit index_path
      expect(current_path).to eq index_path
      within "article#cms-tab-#{node_dataset.id}-0" do
        within "div.pages" do
          click_link page_dataset.name
        end
      end
      expect(status_code).to eq 200

      within "article#cms-tab-#{node_dataset.id}-0" do
        within "div.pages" do
          click_link 'プレビュー'
        end
      end
      expect(status_code).to eq 200

      within "div.resource-content" do
        within "table.cells" do
          expect(page).to have_content('品川')
          expect(page).to have_content('新宿')
        end
      end
    end
  end

  it "index, download" do
    page.driver.browser.with_session("public") do |session|
      session.env("HTTP_X_FORWARDED_HOST", site.domain)
      visit index_path
      expect(current_path).to eq index_path
      within "article#cms-tab-#{node_dataset.id}-0" do
        within "div.pages" do
          click_link page_dataset.name
        end
      end
      expect(status_code).to eq 200

      within "article#cms-tab-#{node_dataset.id}-0" do
        within "div.pages" do
          click_link 'ダウンロード'
        end
      end
      expect(status_code).to eq 200
    end
  end

  it "#rss" do
    layout.html = <<~HTML
      <html>
      <body>
        <br><br><br>
        <h1 id="ss-page-name">\#{page_name}</h1><br>
        <div id="main" class="page">
          {{ yield }}
          <div class="list-footer">
            <a href="#{rss_path}" download>RSS</a>
          </div>
        </div>
      </body>
      </html>
    HTML
    layout.save!

    page.driver.browser.with_session("public") do |session|
      session.env("HTTP_X_FORWARDED_HOST", site.domain)
      visit rss_path

      visit index_path
      within ".list-footer" do
        click_on "RSS"
      end

      xmldoc = REXML::Document.new(page.html)
      title = REXML::XPath.first(xmldoc, "/rss/channel/title/text()").to_s.strip
      expect(title).to start_with(node_dataset.name)
      link = REXML::XPath.first(xmldoc, "/rss/channel/link/text()").to_s.strip
      expect(link).to end_with(node_dataset.url)
      items = REXML::XPath.match(xmldoc, "/rss/channel/item")
      expect(items).to have(1).items
    end
  end

  it "#areas" do
    page.driver.browser.with_session("public") do |session|
      session.env("HTTP_X_FORWARDED_HOST", site.domain)
      visit areas_path
      expect(current_path).to eq areas_path
      expect(page).to have_content(node_area.name)
    end
  end

  it "#tags" do
    page.driver.browser.with_session("public") do |session|
      session.env("HTTP_X_FORWARDED_HOST", site.domain)
      visit tags_path
      expect(current_path).to eq tags_path
      expect(page).to have_content(page_dataset.tags[0])
      expect(page).to have_content(page_dataset.tags[1])
    end
  end

  it "#formats" do
    page.driver.browser.with_session("public") do |session|
      session.env("HTTP_X_FORWARDED_HOST", site.domain)
      visit formats_path
      expect(current_path).to eq formats_path
      expect(page).to have_content('CSV')
    end
  end

  it "#licenses" do
    page.driver.browser.with_session("public") do |session|
      session.env("HTTP_X_FORWARDED_HOST", site.domain)
      visit licenses_path
      expect(current_path).to eq licenses_path
      expect(page).to have_content(license.name)
    end
  end

  it "#show_point" do
    page.driver.browser.with_session("public") do |session|
      session.env("HTTP_X_FORWARDED_HOST", site.domain)
      visit show_point_path
      expect(current_path).to eq show_point_path
      expect(page).to have_content('いいね！')
    end
  end

  it "#point_members" do
    page.driver.browser.with_session("public") do |session|
      session.env("HTTP_X_FORWARDED_HOST", site.domain)
      visit point_members_path
      expect(current_path).to eq point_members_path
      expect(page).to have_selector('ul.point-members')
    end
  end

  it "#show_apps" do
    page.driver.browser.with_session("public") do |session|
      session.env("HTTP_X_FORWARDED_HOST", site.domain)
      visit dataset_apps_path
      expect(current_path).to eq dataset_apps_path
      within "div.detail" do
        within "div.dataset-apps" do
          expect(page).to have_selector('div.apps')
        end
      end
    end
  end

  it "#show_ideas" do
    page.driver.browser.with_session("public") do |session|
      session.env("HTTP_X_FORWARDED_HOST", site.domain)
      visit dataset_ideas_path
      expect(current_path).to eq dataset_ideas_path
      within "div.detail" do
        within "div.dataset-ideas" do
          expect(page).to have_selector('div.ideas')
        end
      end
    end
  end

  it "#datasets_search" do
    page.driver.browser.with_session("public") do |session|
      session.env("HTTP_X_FORWARDED_HOST", site.domain)
      visit datasets_search_path
      expect(current_path).to eq datasets_search_path
    end
  end
end
