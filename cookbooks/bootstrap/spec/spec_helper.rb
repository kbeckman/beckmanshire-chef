require 'chefspec'
require 'chefspec/berkshelf'
require 'pry'

COOKBOOK_NAME = 'bootstrap'.freeze

# NOTE: ChefDK 2.3.4 does not officially include support for mac_os_x/10.13 (High Sierra)...
# TODO: Keep an eye on this and change it when the appropriate updates have been made.
CHEF_SPEC_OPTS = { platform: 'mac_os_x', version: '10.12' }.freeze
