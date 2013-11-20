require 'spec_helper'

feature "User Edit" do
  
  let(:user_1) { FactoryGirl.create(:user) }
  
  
  scenario "user should not be able to access profile page when not signed in" do
    visit root_path

    visit "/users/#{user_1.id}"
    
    current_path.should eq(new_user_session_path)
  end
  
  
  scenario "user should not be able to access edit page when not signed in" do
    visit root_path

    visit "/users/edit.#{user_1.id}"
    
    current_path.should eq(new_user_session_path)
  end
  
  
  scenario "user should be able to access profile page when signed in" do
    visit root_path
    
    within('#signin_on_top') do
      fill_in 'user[email]', :with => user_1.email
      fill_in 'user[password]', :with => 'test1234'
    end
    
    click_button 'Sign In'
    
    click_link 'Profile'
    
    page.should have_selector("h2", :text => user_1.username)
    page.should have_selector("h4", :text => "Subscribed Feeds:")
  end
  
  
  scenario "user should be able to edit info when signed in" do
    visit root_path
    
    within('#signin_on_top') do
      fill_in 'user[email]', :with => user_1.email
      fill_in 'user[password]', :with => 'test1234'
    end
    
    click_button 'Sign In'
    
    click_link 'Profile'
    
    click_link 'Edit Info'
    
    within('#edit_user_info') do
      fill_in 'user[password]', :with => 'abcdefgh'
      fill_in 'user[password_confirmation]', :with => 'abcdefgh'
    end
    
    click_button 'Update Info'
    
    click_link 'Sign out'
    
    current_path.should eq(root_path)
    page.should_not have_link("Profile", :href=>"/users/#{user_1.id}") 
    
    within('#signin_on_top') do
      fill_in 'user[email]', :with => user_1.email
      fill_in 'user[password]', :with => 'abcdefgh'
    end
    
    User.find(user_1.id).valid_password?('abcdefgh').should eq(true)
  end
  
end