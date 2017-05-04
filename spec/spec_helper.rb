require 'rspec/expectations'
require 'appium_lib'
require 'rspec'
require 'sauce_whisk'
require 'selenium-webdriver'
require 'require_all'
require 'eyes_selenium'
require_relative '../pages/schema_parser.rb'

begin
  require_all File.join(File.expand_path(File.dirname(__FILE__)), '..', 'pages').to_s
rescue
  puts 'no page objects found'
end

RSpec.configure do |config|
  config.filter_run_excluding work_in_progress: true

  config.before(:each) do |bonnie_before|
    @base_url = ENV['ACCEPTANCE_TEST_HOST'] || 'https://www.usatoday.com'
    @eyes = Applitools::Eyes.new
    @eyes.api_key = ENV['APPLITOOLS_API_KEY']
    @eyes.match_level = Applitools::Eyes::MATCH_LEVEL[:content]
    @eyes.batch = Applitools::Base::BatchInfo.new ENV['APPLITOOLS_BATCH_NAME'] || 'bonnie-ios'
    @eyes.batch.id = ENV['APPLITOOLS_BATCH_ID'] || Time.new.to_i

    caps = {
      caps: {
        platformVersion: ENV['platformVersion'],
        deviceName: ENV['deviceName'],
        platformName: ENV['platformName'],
        browserName: 'safari',
        deviceOrientation: 'portrait',
        name: bonnie_before.full_description,
        appiumVersion: ENV['appiumVersion'],
        autoAcceptAlerts: true,
        screenshotWaitTimeout: 30
      }
    }

    remote_caps = {
      tags: 'ios-mobileweb'
    }

    local_caps = {
      clearSystemFiles: true,
      fullReset: true,
      automationName: ENV['automationName']
    }

    if ENV['REMOTE']
      caps[:caps].merge!(remote_caps)
    elsif ENV['LOCAL']
      caps[:caps].merge!(local_caps)
      caps[:appium_lib] = { server_url: 'http://0.0.0.0:4723/wd/hub' }
    else
      raise 'Unsupported environment name - use either LOCAL or REMOTE.'
    end

    @driver = Appium::Driver.new(caps)
    @selenium_driver = @driver.start_driver
  end

  config.after(:each) do |bonnie_after|
    featurename = bonnie_after.full_description.to_s.chomp(bonnie_after.description.to_s).strip
    jobname = "#{featurename} - #{bonnie_after.description}"

    if ENV['REMOTE']
      sessionid = @driver.session_id
      puts "SauceOnDemandSessionID=#{sessionid} job-name=#{jobname}"

      if bonnie_after.exception
        SauceWhisk::Jobs.fail_job sessionid
      else
        SauceWhisk::Jobs.pass_job sessionid
      end

    else
      puts "Job-name=#{jobname}"
    end

    @eyes.abort_if_not_closed
    @driver.driver_quit
  end

  # Explicit wait definition
  def wait_for
    Selenium::WebDriver::Wait.new(timeout: 30).until { yield }
  end

  # Navigate to the target URL
  def visit_url(path)
    unless path.include? "://"
      path = @base_url.to_s + path
    end
    @selenium_driver.navigate.to(path)
#    @driver.switch_to_default_context
  end

end
