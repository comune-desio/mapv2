require "yajl"
require_relative "extensions/custom_build"

configure :development do
  activate :livereload
end

activate :dato,
  token: "57b3813bfa9206eecaf8429f8c0f817e3c9ced70df761d8cbf",
  base_url: "https://map.desio.org"

configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :custom_build, dato: dato
end
