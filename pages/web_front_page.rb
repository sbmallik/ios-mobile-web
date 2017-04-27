require_relative "../spec/spec_helper"

class FrontPage
  attr_accessor :driver

  def initialize(driver)
    @driver = driver
  end

  def logo
    @driver.first_ele('header-home')
  end

  def nav_button
    @driver.first_ele('main-nav-btn')
  end

  def nav_hub
    @driver.first_ele('menu-nav-list')
  end

  def section_link(name)
    @section_links_array = @driver.find_elements(:class_name, 'nav-item-link')
    @section_links_array[self.index_for(@section_links_array, name)]
  end

  def index_for(array, name)
    array.find_index do |element|
      element.text.strip.downcase == name.downcase
    end
  end

  def front_logo(front_name)
    @driver.first_ele("header-#{front_name.strip.downcase}")
  end

  def lead_asset_link
    @driver.first_ele('lead-story')
  end

  def asset_header
    @driver.first_ele('story-header')
  end

end
