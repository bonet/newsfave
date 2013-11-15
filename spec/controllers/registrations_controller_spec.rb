require 'spec_helper'

describe RegistrationsController do
  let(:user_1) { FactoryGirl.build(:user) }
  
  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe "GET 'new" do
    before { get :new }
    
    it { response.should be_success }
    it { response.should render_template('users/registrations/new') }
    it { assigns(:title).should eql('Sign Up') }
  end
  
  describe "POST 'create'" do
     
    context "returns correct JSON" do
      it "correct inputs" do
        post :create,  :user => { :username => user_1.username, :email => user_1.email, :password => user_1.password, :password_confirmation => user_1.password_confirmation }
 
        response.should be_success
        body = JSON.parse(response.body)
        body.count.should eql(1)
        body['username'].should eql(user_1.username)
      end
      
      it "incorrect inputs" do
        post :create,  :user => { :username => user_1.username, :email => '', :password => user_1.password, :password_confirmation => user_1.password_confirmation }
        
        response.should_not be_success
        response.status.should eql(422)
        body = JSON.parse(response.body)
        body['errors'].should_not be_blank
      end
    end
  end
end