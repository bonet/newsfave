require 'spec_helper'

describe PagesController do
  
  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end
  
  let(:user_1) { FactoryGirl.build(:user) }
  
  describe "GET 'home" do
    
    before { get :home }
    
    context "Controller variables" do
      it{ assigns(:title).should eq('Home') }
      it { response.should be_success }
      it { response.should render_template('pages/home') }
    end
    
    context "Signed In" do
      it "should have the correct variables" do
        assigns(:result_json).count.should be > 0
        assigns(:result_json)['_id'].should be_integer
        assigns(:result_json)['newsfeed_ids_string'].split(',').count.should be > 0
        assigns(:result_json)['newsfeed_ids_string'].split(',').each { |p| p.to_i.should be > 0 }
      end
    end
    
    context "Not Signed In" do
      it "should have the correct variables" do
        assigns(:result_json).count.should be > 0
        assigns(:result_json)['_id'].should be_integer
        assigns(:result_json)['newsfeed_ids_string'].split(',').count.should be > 0
        assigns(:result_json)['newsfeed_ids_string'].split(',').each { |p| p.to_i.should be > 0 }
      end
    end
  end
  
  
  describe "GET 'feedlist'" do
    context "Controller variables" do
      before { get :feedlist }
      it{ assigns(:title).should eq('Feed List') }
      it { response.should be_success }
      it { response.should render_template('pages/feedlist') }
    end
  end
end