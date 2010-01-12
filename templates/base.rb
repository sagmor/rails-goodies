GOODIES_LOCATION = ENV['GOODIES_LOCATION'] || 'http://github.com/sagmor/rails-goodies/raw/master/'

# Remove unused files
run "echo FILL ME > README"
run "rm public/index.html public/images.rails."


# Basic Gems
gem 'haml'
gem 'BlueCloth', :lib => 'bluecloth'
gem 'mislav-will_paginate', :lib => 'will_paginate', 
                            :source   => 'http://gems.github.com'


# Setup git
git :init
run "curl #{GOODIES_LOCATION}/templates/files/gitignore -o .gitignore"
git :add => '.', :commit => 'Initial Commit'


# Install config loader
run "curl #{GOODIES_LOCATION}/config_loader/config.yml.sample -o config/config.yml.sample"
run "echo 'config/config.yml' >> .gitignore"
run "curl #{GOODIES_LOCATION}/config_loader/config_loader.rb -o lib/config_loader.rb"
run <<-EOF
patch config/environment.rb <<EOP
diff --git a/config/environment.rb b/config/environment.rb
index 029a58b..6ecb031 100644
--- a/config/environment.rb
+++ b/config/environment.rb
@@ -7,2 +7,3 @@ # Bootstrap the Rails environment, frameworks, and default configuration
 require File.join(File.dirname(__FILE__), 'boot')
+require "config_loader"
 

EOP
EOF

git :add => '.', :commit => 'Installed Config Loader'

# Authentication
if yes?('Perform Authentication?')
  user_model = ask 'User Model'
  plugin 'restful-authentication', :git => 'git://github.com/technoweenie/restful-authentication.git'
  generate :authenticated, user_model, 'Session'
  git :add => '.', :commit => 'Basic Authentication'
end
