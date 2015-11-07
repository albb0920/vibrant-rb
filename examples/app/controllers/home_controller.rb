class HomeController < ApplicationController
  def index

    @path = Rails.public_path.join('octocat.png')

    vibrant = Vibrant::Vibrant.new(@path, color_count:64)

    @swatches = vibrant.swatches

    @vibrant      = @swatches[:vibrant].try(:hex)
    @muted        = @swatches[:muted].try(:hex)
    @dark_vibrant = @swatches[:dark_vibrant].try(:hex)
    @dark_muted = @swatches[:dark_muted].try(:hex)
    @light_vibrant = @swatches[:light_vibrant].try(:hex)
    @light_muted = @swatches[:light_muted].try(:hex)

  end
end
