class StaticPagesController < ApplicationController
  def home
    @images = Image.where(public: true)
  end
end
