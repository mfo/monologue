# frozen_string_literal: true
require 'spec_helper'

describe 'tags', type: :feature do
  context 'creating a post as a logged in user' do
    before(:each) do
      Factory(:site)
      log_in
      visit new_admin_post_path
      fill_in 'Title', with:  'title'
      fill_in 'Content', with:  'content'
      fill_in 'Published at', with:  DateTime.now
    end

    it 'saves a post when the tag list ends with with a comma' do
      fill_in 'Tags', with: '  rails, ruby, '
      click_button 'Save'
      page.should have_field :post_tag_list, with: 'rails, ruby'
    end

    it 'ignores an empty tag between two commas' do
      fill_in 'Tags', with: '  rails, ,ruby'
      click_button 'Save'
      page.should have_field :post_tag_list, with: 'rails, ruby'
    end
  end
end
