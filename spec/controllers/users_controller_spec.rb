require 'spec_helper'

describe UsersController do
  
  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end
  
  let(:user_1) { FactoryGirl.create(:user) }
  
  describe "GET 'show'" do
    before do 
      user_1.save
      session[:user_id] = user_1.id   # sign in
      get :show,  :id => user_1.id  
    end
    
    describe "processes correctly" do
      it { response.should be_success }
      it { response.should render_template('users/show') }
      it "has the correct categories_per_publisher_hash" do 
        assigns(:categories_per_publisher_hash).each do |publisher, category_array|
          publisher.should be_kind_of(String)
          category_array.first.should be_kind_of(String)
        end
      end
    end
  end
end
