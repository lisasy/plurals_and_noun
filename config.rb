set :haml, :format => :html5

page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

set :relative_links, true
set :images_dir, "images"

activate :automatic_image_sizes
activate :directory_indexes
activate :i18n
activate :asset_hash

configure :development do
  activate :livereload
end

configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :relative_assets
end

configure :deploy do |deploy|
  deploy.deploy_method = :git
  deploy.build_before = true
  deploy.branch = "master"
end
