# require 'middleman-core/load_paths'
# ::Middleman.setup_load_paths
#
# require 'middleman-core'
# require 'middleman-core/rack'
#
# require 'fileutils'
# FileUtils.mkdir('log') unless File.exist?('log')
# ::Middleman::Logger.singleton("log/#{ENV['RACK_ENV']}.log")
#
# app = ::Middleman::Application.new
#
# run ::Middleman::Rack.new(app).to_app
#
require "rack"
require "rack/contrib/try_static"

# Enable proper HEAD responses
use Rack::Head

# Add basic auth if configured
if ENV["HTTP_USER"] && ENV["HTTP_PASSWORD"]
  use Rack::Auth::Basic, "Restricted Area" do |username, password|
    [username, password] == [ENV["HTTP_USER"], ENV["HTTP_PASSWORD"]]
  end
end

# Attempt to serve static HTML files
use Rack::TryStatic,
    :root => "build",
    :urls => %w[/],
    :try => ['.html', 'index.html', '/index.html']

# Serve a 404 page if all else fails
run lambda { |env|
  [
    404,
    {
      "Content-Type" => "text/html",
      "Cache-Control" => "public, max-age=60"
    },
    File.open("build/404/index.html", File::RDONLY)
  ]
}
