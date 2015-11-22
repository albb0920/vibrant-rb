class HomeController < ApplicationController
  def index

    @types = [
        :vibrant, :muted,
        :dark_vibrant,
        :dark_muted,
        :light_vibrant,
        :light_muted
    ]

    @png_path ='octocat.png'
    @png_vibrant = Vibrant.read(Rails.public_path.join(@png_path))

    @jpg_path = '1.jpg'
    @jpg_vibrant = Vibrant.read(Rails.public_path.join(@jpg_path))

  end
end
