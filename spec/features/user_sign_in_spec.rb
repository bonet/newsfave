require 'spec_helper'

feature "User Sign In" do
  
  let(:user_1) { FactoryGirl.create(:user) }
  
  scenario "User should not be able to sign in with wrong credentials" do
    
    visit root_path
    
    within('#signin_on_top') do
      fill_in 'user[email]', :with => user_1.email
      fill_in 'user[password]', :with => 'wrong_password'
    end
    
    click_button 'Sign In'
    
    current_path.should eq(new_user_session_path)
    
    page.should_not have_link("Profile", :href=>"/users/#{user_1.id}") 
  end
  
  
  scenario "User should be able to sign in with correct credentials" do
    
    visit root_path
    
    within('#signin_on_top') do
      fill_in 'user[email]', :with => user_1.email
      fill_in 'user[password]', :with => 'test1234'
    end
    
    click_button 'Sign In'
    
    current_path.should eq(root_path)
    page.should have_link("Profile", :href=>"/users/#{user_1.id}") 
  end
  
  
  scenario "User should be able to sign out after signed in" do
    
    visit root_path
    
    within('#signin_on_top') do
      fill_in 'user[email]', :with => user_1.email
      fill_in 'user[password]', :with => 'test1234'
    end
    
    click_button 'Sign In'
    
    current_path.should eq(root_path)
    
    click_link 'Sign out'
    
    page.should have_link("Personalize!")
    page.should_not have_link("Profile", :href=>"/users/#{user_1.id}") 
  end
end