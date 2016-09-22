require "git_wand"
require "json"
require "securerandom"
require "pry"

class CustomBuild < Middleman::Extension
  option :dato
  def initialize(app, options = {}, &block)
    super
    @dato = options[:dato]
  end

  def after_build(builder)
    client = GitWand::GitHub::API::Client.new(username: ENV["GITHUB_USERNAME"], token: ENV["GITHUB_TOKEN"])
    owner = "comune-desio"
    repo = "opendata"
    path = "poi--build.json"
    data = @dato.datasets.map do |dataset|
      {
        "Dataset" => dataset.name,
        "Visible" => !dataset.hidden,
        "Categories" => dataset.categories.map do |category|
          {
            "Category" => category.name,
            "Icon" => "#{category.icon.name}.png",
            "Locations" => category.locations.map do |location|
              {
                "Address" => location.address,
                "Latitude" => location.latitude.to_f,
                "Longitude" => location.longitude.to_f,
                "Note" => location.note || "",
                "Link" => location.url || ""
              }
            end
          }
        end
      }
    end
    client.update_file(owner: owner, repo: repo, branch: "master", path: path, message: "Builds dataset #{path} from DatoCMS", content: JSON.pretty_generate(data))
  end
end

::Middleman::Extensions.register(:custom_build, CustomBuild)
