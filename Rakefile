# Remote Testing iOS

def remote_ios_tests(deviceName, platformName, platformVersion, appiumVersion)
  environment_variables = {
    'REMOTE' => 'true',
    'PARALLEL_SPLIT_TEST_PROCESSES' => ARGV[1],
    'deviceName' => deviceName,
    'platformName' => platformName,
    'platformVersion' => platformVersion
  }
  system(environment_variables, "parallel_split_test spec/*_spec.rb --format progress --format RspecJunitFormatter --out test_results/results.xml --format ParallelTests::RSpec::FailuresLogger --out test_results/failed_tests.log #{ENV['test_options']}")
  fail 'remote_ios_tests' unless $?.exitstatus == 0
end

# Local Testing iOS
def local_ios_tests(deviceName, platformName, platformVersion, appiumVersion, automationName)
  environment_variables = {
    'LOCAL' => 'true',
    'deviceName' => deviceName,
    'platformName' => platformName,
    'platformVersion' => platformVersion,
    'automationName' => automationName
  }
  system(environment_variables, "rspec spec/*_spec.rb #{ENV['test_options']}")
  fail 'local_ios_tests' unless $?.exitstatus == 0
end

# iOS Simulators
task :ios_simulator do
  remote_ios_tests('iPhone Simulator', 'iOS', '9.3', '1.5.3')
end

# Local iOS Simulator
task :local_ios do
  local_ios_tests('iPhone 6', 'iOS', '9.3', '1.6.4', 'XCUITest')
end

multitask :test_sauce => [
    :ios_simulator
  ] do
    puts 'Running USAT web Automation'
end
