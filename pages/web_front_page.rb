require_relative "../spec/spec_helper"

class FrontPage
  attr_accessor :driver

  def initialize(driver)
    @driver = driver
  end

  def logo
    @driver.find_element(:class_name, 'header-home')
  end

  def nav_button
    @driver.find_element(:class_name, 'main-nav-btn')
  end

  def nav_hub
    @driver.find_element(:class_name, 'menu-nav-list')
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
    @driver.find_element(:class_name, "header-#{front_name.strip.downcase}")
  end

  def lead_asset_link
    @driver.find_element(:class_name, 'lead-story')
  end

  def asset_header
    @driver.find_element(:class_name, 'story-header')
  end

end
