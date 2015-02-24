# dir = File.expand_path(File.dirname(__FILE__))
# $LOAD_PATH.unshift File.join(dir, 'lib')

# require 'mocha'
# require 'puppet'
# require 'rspec'

# Spec::Runner.configure do |config|
#     config.mock_with :mocha
# end

require 'puppetlabs_spec_helper/module_spec_helper'

require 'puppet-lint'

PuppetLint.configuration.send("disable_class_inherits_from_params_class")
PuppetLint.configuration.send("disable_80chars")
PuppetLint.configuration.ignore_paths = ['pkg/**/*.pp', 'spec/**/*.pp', 'tests/**/*.pp']
