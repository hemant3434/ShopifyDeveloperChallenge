require 'rails_helper'
require 'spec_helper'
include SessionsHelper
RSpec.describe ImagesController do
  let(:user) { User.create!(email: 'example@railstutorial.org', password: 'foobar', password_confirmation: 'foobar') }
  describe "POST /image_view" do
    
    before(:each) do
      post login_path, params: { session:{ email: user.email, password: 'foobar' } }
    end

    after(:each) do
      delete logout_path
      Image.destroy_all
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
        delete logout_path
        img = Image.create!(user_id: user.id, public: false)
        post '/image_view', params: { image_id: img.id, public: true }
        expect(response).to redirect_to(root_url)
        expect(user.images.first.public).to eq(false)
      end
    end
  end

  describe "POST images_path" do
    before(:each) do
      post login_path, params: { session:{ email: user.email, password: 'foobar' } }
    end

    after(:each) do
      delete logout_path
      Image.destroy_all
    end

    context 'when multiple files are sent' do
      it 'should get uploaded and added to users images' do
        test_photo = Rack::Test::UploadedFile.new("#{Rails.root}/spec/requests/dummy.png")
        test_photo2 = Rack::Test::UploadedFile.new("#{Rails.root}/spec/requests/dummy.png")
        post images_path, params: { image: { public: true, picture: [test_photo, test_photo2] } }

        expect(user.images.count).to eq(2)
        expect(response.status).to eq(301)
      end
    end

    context 'when multiple non image files are sent' do
      it 'should not get uploaded and should not be added to users images if they are not images' do
        test_photo = Rack::Test::UploadedFile.new("#{Rails.root}/spec/requests/dummy.png")
        test_photo2 = Rack::Test::UploadedFile.new("#{Rails.root}/spec/requests/dummy.txt")
        post images_path, params: { image: { public: true, picture: [test_photo, test_photo2] } }

        expect(user.images.count).to eq(1)
        expect(response.status).to eq(301)
      end
    end

    context 'when no files are sent' do
      it 'should not get uploaded and should not be added to users images' do
        post images_path, params: { image: { public: true, picture: [] } }

        expect(user.images.count).to eq(0)
        expect(response.status).to eq(301)
      end
    end

    context 'when a image too large is sent' do
      it 'should not get uploaded and should not be added to users images if > 1.5 MB' do
        test_photo = Rack::Test::UploadedFile.new("#{Rails.root}/spec/requests/dummy.png")
        test_photo2 = Rack::Test::UploadedFile.new("#{Rails.root}/spec/requests/2MB.jpg")
        post images_path, params: { image: { public: true, picture: [test_photo, test_photo2] } }

        expect(user.images.count).to eq(1)
        expect(response.status).to eq(301)
      end
    end
  end
end
