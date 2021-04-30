require 'rails_helper'
require 'spec_helper'
RSpec.describe ImagesController do
  describe "POST /image_view" do
    let(:user) { User.create!(email: 'example@railstutorial.org', password: 'foobar', password_confirmation: 'foobar') }
    
    before(:each) do
      CurrentUser.create!(cur: user.id) if CurrentUser.all.count == 0
      CurrentUser.first.update_attributes(cur: user.id)
    end

    after(:each) do
      User.destroy_all
    end

    context 'when user is signed in and wants to update his image permissions' do
      it 'should update the image permissions as necessary' do
        img = Image.create!(user_id: user.id, public: false)
        post '/image_view', params: { public: true, image_id: img.id }
        expect(response).to redirect_to(user_path(user))
        expect(response.status).to eq(301)
        expect(user.images.first.public).to eq(true)
      end
    end

    context 'when req does not get a image id' do
      it 'should redirect back with a specificed status 300' do
        post '/image_view', params: { public: true }
        expect(response).to redirect_to(user_path(user))
        expect(response.status).to eq(300)
      end
    end

    context 'when req does not get a params stating its publicity' do
      it 'should redirect back with a specificed status 300 and not update its publicity' do
        img = Image.create!(user_id: user.id, public: false)
        post '/image_view', params: { image_id: img.id }
        expect(response).to redirect_to(user_path(user))
        expect(response.status).to eq(300)
        expect(user.images.first.public).to eq(false)
      end
    end

    context 'a user tries to update images that dont belong to him/her' do
      it 'should not update the permissions' do
        user2 = User.create!(email: 'a@a.ca', password: 'foobar', password_confirmation: 'foobar')
        CurrentUser.first.update_attributes(cur: user2.id)
        img = Image.create!(user_id: user.id, public: false)
        post '/image_view', params: { image_id: img.id, public: true }
        expect(response).to redirect_to(user_path(user2))
        expect(response.status).to eq(301)
        expect(user.images.first.public).to eq(false)
      end
    end
  end
end
