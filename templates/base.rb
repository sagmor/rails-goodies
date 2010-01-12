GOODIES_LOCATION = ENV['GOODIES_LOCATION'] || 'http://github.com/sagmor/rails-goodies/raw/master'


# Some usefull methods
def download(files)
  files.each do |from, to|
    run "curl -# #{GOODIES_LOCATION}/#{from} -o #{to}"
  end
end

def patch(file, the_patch)
  run "patch #{file} <<EOP\n#{the_patch}\nEOP"
end

# Remove unused files
run "echo FILL ME > README"
run "rm public/index.html public/images.rails."


# Basic Gems
gem 'haml'
gem 'BlueCloth', :lib => 'bluecloth'
gem 'mislav-will_paginate', :lib => 'will_paginate', 
                            :source   => 'http://gems.github.com'
rake 'gem:install', :sudo => true

# Setup git
git :init
download 'templates/files/gitignore' => '.gitignore'
run "cp config/database.yml config/database.yml.sample"
git :add => '.'
git :commit => "-m 'Initial Commit'"


# Install config loader
download  'config_loader/config.yml.sample' => 'config/config.yml.sample',
          'config_loader/config_loader.rb' => 'lib/config_loader.rb'

run "echo 'config/config.yml' >> .gitignore"

patch 'config/environment.rb', <<-EOP
diff --git a/config/environment.rb b/config/environment.rb
index 029a58b..6ecb031 100644
--- a/config/environment.rb
+++ b/config/environment.rb
@@ -7,2 +7,3 @@ # Bootstrap the Rails environment, frameworks, and default configuration
 require File.join(File.dirname(__FILE__), 'boot')
+require "config_loader"
 

EOP

git :add => '.'
git :commit => "-m 'Installed Config Loader'"

# Authentication
if yes?('Perform Authentication?')
  user_model = ask 'User Model'
  plugin 'restful-authentication', :git => 'git://github.com/technoweenie/restful-authentication.git'
  generate :authenticated, user_model, 'Session'
  git :add => '.', :commit => "-m 'Basic Authentication'"
end
