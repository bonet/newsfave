require 'spec_helper'

describe RegistrationsController do
  
  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end
  
  before do
    categories_per_publisher = {"1"=>
                                {"publisher_id"=>1,
                                 "publisher_name"=>"Washington Post",
                                 "categories"=>
                                  [{"newsfeed_id"=>2,
                                    "category_id"=>1,
                                    "category_name"=>"Art",
                                    "owned"=>"true"}]},
                               "2"=>
                                {"publisher_id"=>2,
                                 "publisher_name"=>"New York Times",
                                 "categories"=>
                                  [{"newsfeed_id"=>3,
                                    "category_id"=>2,
                                    "category_name"=>"Technology",
                                    "owned"=>"true"},
                                   {"newsfeed_id"=>4,
                                    "category_id"=>1,
                                    "category_name"=>"Art",
                                    "owned"=>"false"}]}
                              }
  end
  
  let(:user_1) { FactoryGirl.build(:user) }

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
  
  
  describe "GET 'edit'" do
    
    before do
      user_1.save
      session[:user_id] = user_1.id   # sign in
      user_1.stub(:retrieve_categories_per_publisher_json) { categories_per_publisher }
      get :edit
    end
    
    context "processes the request correctly" do
      it { response.should be_success }
      it { response.should render_template('users/registrations/edit') }
      it { assigns(:categories_per_publisher_json).should_not be_blank }
    end
    
  end
  
  
  describe "PUT 'update'" do
    before do
      user_1.save
      session[:user_id] = user_1.id   # sign in
      user_1.stub(:retrieve_categories_per_publisher_json) { categories_per_publisher }
      put :update, :user => { :password => "newpassword", :password_confirmation => "newpassword" }
    end
    
    context "processes the request correctly" do
      it { response.should redirect_to(edit_user_registration_path) }
    end
    
    context "updates the password" do
      it { assigns(:user).valid_password?("newpassword").should eql(true) }
    end
  end
  
  
  describe "POST 'feed_subscribe'" do
    before do
      user_1.save
      session[:user_id] = user_1.id   # sign in
      post :feed_subscribe, :newsfeed_ids => "1,2,3"
      user_1.reload
    end
    
    it "should return the correct JSON" do
      body = JSON.parse(response.body)
      body['newsfeed_aggregate_id'].should eq(user_1.newsfeed_aggregate_id.to_s)
    end
  end
end