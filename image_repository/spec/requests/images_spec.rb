require 'rails_helper'
require 'spec_helper'

RSpec.describe ImagesController do
  describe "POST /image_view" do
    context 'when user is signed in and wants to update his image permissions' do
      it 'should update the image permissions as necessary' do
        expect(true).to eq(true)
      end
    end

    context 'when req does not get a image id or does not state its permissions' do
      it 'redirect back with a specificed status' do
      end
    end

    context 'a user tries to update images that dont belong to him/her' do
      it 'should not update the permissions' do
      end
    end
  end
end
