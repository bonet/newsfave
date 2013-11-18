require 'spec_helper'

describe User do
  
  let(:user1) { FactoryGirl.create(:user) }
  
  context "Class Attributes" do
    [:username, :email, :password, :password_confirmation].each do |attribute|
        it { should allow_mass_assignment_of(attribute) }
    end
    
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }  
    it { should allow_value("email@addresse.foo").for(:email) }
    it { should_not allow_value("foo").for(:email) }  
    it { should_not allow_value("addresse.foo").for(:email) }
    it { should_not allow_value("@addresse.foo").for(:email) }
    it { should validate_confirmation_of(:password) }  
    it { should ensure_length_of(:password).is_at_least(8) }
    it { should ensure_length_of(:password).is_at_most(128) }
  end
  
  context "Get newsfeed Aggregate" do
    context "- Default" do
      it "should return the correct JSON" do
        json = User.get_newsfeed_aggregate_json
        json.count.should be > 0
        json['_id'].should be_integer
        json['newsfeed_ids_string'].split(',').count.should be > 0
        json['newsfeed_ids_string'].split(',').each { |p| p.to_i.should be > 0 }
        json['newsfeed_aggregate_per_category_ids'].count.should be > 0
        json['newsfeed_aggregate_per_category_ids'].each { |p| p.should be > 0 }
        json['newsfeed_aggregate_per_publisher_ids'].count.should be > 0
        json['newsfeed_aggregate_per_publisher_ids'].each { |p| p.should be > 0 }
        json['newsfeed_aggregate_per_categories'].first['category_id'].should be > 0
        json['newsfeed_aggregate_per_categories'].first['content_urls'].should_not be_blank
        json['newsfeed_aggregate_per_publishers'].first['publisher_id'].should be > 0
        json['newsfeed_aggregate_per_publishers'].first['content_urls'].should_not be_blank
      end
    end
    
    context "- Personalized (with newsfeed_aggregate_id)" do
      it "should return the correct JSON" do
        user1.subscribe_to_newsfeeds('1,2')   # subscribe `newsfeed_ids` to newsfeeds to get personalized NewsfeedAggregate
        json = user1.retrieve_newsfeed_aggregate_json
        json.count.should be > 0
        json['_id'].should be_integer
        json['newsfeed_ids_string'].split(',').count.should be > 0
        json['newsfeed_ids_string'].split(',').each { |p| p.to_i.should be > 0 }
        json['newsfeed_aggregate_per_category_ids'].count.should be > 0
        json['newsfeed_aggregate_per_category_ids'].each { |p| p.should be > 0 }
        json['newsfeed_aggregate_per_publisher_ids'].count.should be > 0
        json['newsfeed_aggregate_per_publisher_ids'].each { |p| p.should be > 0 }
        json['newsfeed_aggregate_per_categories'].first['category_id'].should be > 0
        json['newsfeed_aggregate_per_categories'].first['content_urls'].should_not be_blank
        json['newsfeed_aggregate_per_publishers'].first['publisher_id'].should be > 0
        json['newsfeed_aggregate_per_publishers'].first['content_urls'].should_not be_blank
      end
    end
    
    context "- Personalized (with newsfeed_aggregate_id blank?, a.k.a Default result)" do
      it "should return the correct JSON" do
        json = user1.retrieve_newsfeed_aggregate_json # DON'T subscribe `newsfeed_ids` to newsfeeds to get DEFAULT NewsfeedAggregate
        json.count.should be > 0
        json['_id'].should be_integer
        json['newsfeed_ids_string'].split(',').count.should be > 0
        json['newsfeed_ids_string'].split(',').each { |p| p.to_i.should be > 0 }
        json['newsfeed_aggregate_per_category_ids'].count.should be > 0
        json['newsfeed_aggregate_per_category_ids'].each { |p| p.should be > 0 }
        json['newsfeed_aggregate_per_publisher_ids'].count.should be > 0
        json['newsfeed_aggregate_per_publisher_ids'].each { |p| p.should be > 0 }
        json['newsfeed_aggregate_per_categories'].first['category_id'].should be > 0
        json['newsfeed_aggregate_per_categories'].first['content_urls'].should_not be_blank
        json['newsfeed_aggregate_per_publishers'].first['publisher_id'].should be > 0
        json['newsfeed_aggregate_per_publishers'].first['content_urls'].should_not be_blank
      end
    end
  end
  
  context "Get Categories per Publisher" do
    context "- Default" do
      it "should return the correct JSON" do
        json = User.get_categories_per_publisher_json
        json['1']['publisher_id'].should be > 0
        json['1']['publisher_name'].should_not be_blank
        json['1']['categories'][0]['category_id'].should be > 0
        json['1']['categories'][0]['category_name'].should_not be_blank
        json['1']['categories'][0]['newsfeed_id'].should be > 0
      end
    end
    
    context "- Personalized (with newsfeed_aggregate_id)" do
      it "should return the correct JSON" do
        user1.subscribe_to_newsfeeds('1,2')   # subscribe `newsfeed_ids`
        json = user1.retrieve_categories_per_publisher_json
        json['1']['publisher_id'].should be > 0
        json['1']['publisher_name'].should_not be_blank
        json['1']['categories'][0]['category_id'].should be > 0
        json['1']['categories'][0]['category_name'].should_not be_blank
        json['1']['categories'][0]['newsfeed_id'].should be > 0
      end
    end
    
    context "- Personalized (with newsfeed_aggregate_id blank?, a.k.a Default result)" do
      it "should return the correct JSON" do
        json = user1.retrieve_categories_per_publisher_json  # don't subscribe `newsfeed_ids` to retrieve default
        json['1']['publisher_id'].should be > 0
        json['1']['publisher_name'].should_not be_blank
        json['1']['categories'][0]['category_id'].should be > 0
        json['1']['categories'][0]['category_name'].should_not be_blank
        json['1']['categories'][0]['newsfeed_id'].should be > 0
      end
    end
  end
  
  context "Subscribe Newsfeed IDs" do
    
    before do
      user1.subscribe_to_newsfeeds('1,2')
    end
    
    it "should give User a NewsfeedAggregate ID" do
      user1.newsfeed_aggregate_id.should be > 0
    end
    
    it "should return the correct JSON" do
      user1.retrieve_categories_per_publisher_json.each do |key, publisher|
        if [1,2].include?(publisher['categories'].first['newsfeed_id'])
          publisher['categories'].first['owned'].should eq("true")
        else
          publisher['categories'].first['owned'].should eq("false")
        end
      end
    end
  end

end