class ImagesController < ApplicationController
  before_action :logged_in, only: [:create, :image_view]
  def create
    image_params[:picture]&.each do |pic|
      arg = { 
        picture: pic,
        public: image_params[:public]
      }
      @image = Image.create(arg)
      current_user.images << @image if @image.picture&.url&.present?
      if @image.picture&.url&.present?
        flash_message('success', "Successfully uploaded #{pic&.original_filename}")
      else
        flash_message('error', "Could not upload #{pic&.original_filename}. Make sure its a jpg/jpeg/png and < 1.5MB")
      end
    end
    redirect_to user_path(current_user), status: 301
  end

  def image_view
    redirect_to(user_path(current_user), status: 300) and return if params[:image_id].blank? || params[:public].blank?
    current_user.images.where(id: params[:image_id])&.first&.update_attributes(public: params[:public])
    flash_message('success', 'Image Access Modified!')
    redirect_to user_path(current_user), status: 301
  end

  private
  def image_params
    params.require(:image).permit(:public, picture: [])
  end

end
