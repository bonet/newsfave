require 'spec_helper'

feature "Pages" do
  
  scenario "Main page should have the correct content", js: true do
    visit root_path
    
    page.should have_content 'Filter by:'
    
    page.should have_selector 'li.content-tab'
    page.should have_selector '#category-content'
    page.should have_selector '.content-url'
    
    choose('Publisher')
    page.should have_selector 'li.content-tab'
    page.should have_selector '#publisher-content'
    page.should have_selector '.content-url'
    
  end
  
  scenario "About page should have the correct content" do
    visit about_path
    page.should have_css 'h1', :text => 'About Us'
  end
  
  scenario "Contact page should have the correct content" do
    visit contact_path
    page.should have_css 'h1', :text => 'Contact'
  end
  
  scenario "Feedlist page should have the correct content" do
    visit feedlist_path
    page.should have_content 'Coming Soon!'
  end
end