# encoding: UTF-8
# frozen_string_literal: true
require 'spec_helper'
describe 'users', type: :feature do
  let(:user) { Factory(:user) }

  before do
    log_in user
  end

  it 'makes sure the link to user edit screen is present', js: true do
    page.has_content?('Logged in!')
    within '.navbar' do
      click_link I18n.t('layouts.monologue.admin.nav_bar.settings')
      click_link I18n.t('layouts.monologue.admin.nav_bar.edit_user_info')
    end
  end

  context 'edit' do
    before do
      visit edit_admin_user_path(user)
    end

    it 'validates user name is present' do
      fill_in 'user_name', with: ''
      click_button 'Save'
      page.should have_content('Name is required')
    end

    it 'validates email is present' do
      fill_in 'user_email', with: ''
      click_button 'Save'
      page.should have_content('Email is required')
    end

    it 'validates user password and confirmation match' do
      fill_in 'user_password', with: 'password'
      fill_in 'user_password', with: 'password2'
      click_button 'Save'
      page.should have_content("doesn't match Password")
    end

    it "doesn't change password if none is provided" do
      password_before = ::Monologue::User.where(email: user.email)
                                         .first
                                         .password_digest
      click_button 'Save'
      ::Monologue::User.where(email: user.email)
                       .first
                       .password_digest.should eq(password_before)
    end
  end

  context 'Logged in' do
    let!(:user_without_post) { Factory(:user) }
    let!(:user_with_post) { Factory(:user_with_post) }

    it 'should be able to see the list of available users' do
      visit admin_users_path
      page.should have_content(user_without_post.email)
      page.should have_content(user_with_post.email)
    end

    it 'should be able to create a new user' do
      visit admin_users_path
      click_on I18n.t('monologue.admin.users.index.create')
      fill_in 'user_name', with: 'John'
      fill_in 'user_email', with: 'john@doe.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      click_button I18n.t('monologue.admin.users.new.create')
      page.should have_content(I18n.t('monologue.admin.users.create.success'))
    end

    it 'should not be able to delete user with posts' do
      visit admin_users_path
      delete = I18n.t('monologue.admin.users.index.delete')
      page.should_not have_link(delete, href: admin_user_path(user_with_post))
      page.should_not have_link(delete, href: admin_user_path(user))
      page.should have_link(delete, href: admin_user_path(user_without_post))
    end
  end
end
