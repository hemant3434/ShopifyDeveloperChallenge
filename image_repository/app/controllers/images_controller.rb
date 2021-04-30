class ImagesController < ApplicationController
  def create
    image_params[:picture]&.each do |pic|
      arg = { 
        picture: pic,
        public: image_params[:public]
      }
      @image = current_user.images.build(arg)
      @image.save!
    end
    redirect_to user_path(current_user)
  end

  def image_view
    Image.find(params[:image_id]).update_attributes(public: params['public'])
    flash[:success] = "Image Access Modified!"
    redirect_to user_path(current_user)
  end

  private
  def image_params
    params.require(:image).permit(:public, picture: [])
  end
end
