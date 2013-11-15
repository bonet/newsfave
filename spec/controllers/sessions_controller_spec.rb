require 'spec_helper'

describe SessionsController do
  
  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end
  
  let(:user_1) { FactoryGirl.create(:user) }
  before { user_1 }
  
  describe "GET 'new'" do
    before { get :new }
    it { response.should be_success }
    it { response.should render_template('users/sessions/new') }
    it { assigns(:title).should eql('Sign In') }
  end
  
  describe "POST 'create'" do
    context "Login" do
      it "correct inputs" do
        post :create,  :user => { :email => user_1.email, :password => user_1.password }

        response.should redirect_to(root_path)
        session[:user_id].should eql(user_1.id)
      end
      
      it "incorrect inputs" do
        post :create,  :user => { :email => user_1.email, :password => '' }

        response.should render_template('users/sessions/new')
        session[:user_id].should be_blank
      end
    end
  end
  
  describe "DELETE 'destroy'" do
    context "Logout" do
      it "logging out" do
        post :create,  :user => { :email => user_1.email, :password => user_1.password }
        
        session[:user_id].should eql(user_1.id)
        
        get :destroy
        
        session[:user_id].should be_blank
      end
    end
  end
end