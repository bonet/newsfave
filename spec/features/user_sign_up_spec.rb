require 'spec_helper'

feature "User Sign Up" do
  
  let(:user_1) { FactoryGirl.build(:user) }
  
  scenario "User should see error messages when providing invalid input", js: true do
    
    visit root_path
    
    click_link 'Personalize!'
    
    within('#signup_step1') do
      fill_in 'user[username]', :with => user_1.username
      fill_in 'user[email]', :with => 'blah'
      fill_in 'user[password]', :with => ''
      fill_in 'user[password_confirmation]', :with => 'test1234'
    end
    
    click_button 'Sign Up'
    
    page.should have_content('Email is invalid')
    page.should have_content('Password can\'t be blank')
    page.should have_content('Password doesn\'t match confirmation')
    
  end
  
  scenario "User should not be able to sign up with already existing email", js: true do

    user_1.save!
    user_1.reload
    
    visit root_path
    
    click_link 'Personalize!'
    
    within('#signup_step1') do
      fill_in 'user[username]', :with => user_1.username
      fill_in 'user[email]', :with => user_1.email
      fill_in 'user[password]', :with => 'test1234'
      fill_in 'user[password_confirmation]', :with => 'test1234'
    end
    
    click_button 'Sign Up'
    
    page.should_not have_content('Choose Feeds')
  end
  
  scenario "User should be able to sign up when all inputs are valid and the email is not already in the database", js: true do
    
    visit root_path
    
    click_link 'Personalize!'
    
    within('#signup_step1') do
      fill_in 'user[username]', :with => user_1.username
      fill_in 'user[email]', :with => user_1.email
      fill_in 'user[password]', :with => 'test1234'
      fill_in 'user[password_confirmation]', :with => 'test1234'
    end
    
    click_button 'Sign Up'
    
    page.should have_content('Choose Feeds')
    
    c = User.get_categories_per_publisher_json
    
    publisher_id_1 = "#publisher" + c.values[1]['publisher_id'].to_s
    publisher_id_2 = "#publisher" + c.values[0]['publisher_id'].to_s
    newsfeed_id_1 = "newsfeed." + c.values[1]['categories'][0]['newsfeed_id'].to_s
    newsfeed_id_2 = "newsfeed." + c.values[0]['categories'][0]['newsfeed_id'].to_s
    
    page.find(publisher_id_1).trigger(:mouseover) 
    page.check(newsfeed_id_1)                     
    page.find(publisher_id_2).trigger(:mouseover)
    page.check(newsfeed_id_2)
    
    click_button 'Subscribe'
    
    current_path.should eq(root_path)
    
    new_user = User.find_by_email(user_1.email)
    
    page.should have_link("Profile", :href=>"/users/#{new_user.id}") 
    
  end
end