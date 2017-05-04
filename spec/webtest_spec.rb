require_relative "spec_helper"
FRONT_NAME='Money'

describe 'iOS web', :web_demo do

  it 'run the first test' do 
    front_page = FrontPage.new @selenium_driver
    visit_url '/'
    wait_for { front_page.logo.displayed? }
    wait_for { front_page.nav_button.displayed? }
    front_page.nav_button.click
    wait_for { front_page.nav_hub.displayed? }
    expect(front_page.section_link(FRONT_NAME).displayed?).to be true
    front_page.section_link(FRONT_NAME).click
    wait_for { front_page.front_logo(FRONT_NAME).displayed? }
    lead_asset_url = front_page.lead_asset_link.attribute('href')
    front_page.lead_asset_link.click
    wait_for { front_page.asset_header.displayed? }
    expect(@selenium_driver.current_url).to match lead_asset_url
  end

end
