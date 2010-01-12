#
# This file is used to load Environment variables from RAILS_ROOT/config/config.yml if exists
# 
# Installation:
#   Put this file on the 'lib' directory and call require 'config_loader' after loading boot in environment.rb
#

require 'yaml'

config = File.join(RAILS_ROOT, 'config', 'config.yml')
if File.exists? config
  # Here we do a Hash#reverse_merge! manually because ActiveSupport isn't loaded
  ENV.replace( YAML.load_file(config)[RAILS_ENV].merge(ENV) )
end
