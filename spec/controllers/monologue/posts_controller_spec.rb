# frozen_string_literal: true
require 'spec_helper'

describe Monologue::PostsController do
  before do
    @routes = Monologue::Engine.routes
  end

  describe 'GET #index' do
    context 'archive_posts' do
      before do
        site = FactoryGirl.create(:site)
        archive_post1 = FactoryGirl.create(:post,
                                           published_at: Date.parse('10-10-10'),
                                           site: site)
        archive_post2 = FactoryGirl.create(:post,
                                           published_at: Date.parse('11-11-11'),
                                           site: site)
        archive_post2.save(validate: false)
        @request.env["HTTP_HOST"] = "www.#{site.domain}"
        get :index, nil
      end

      it { expect(assigns(:archive_posts).length).to eq 2 }
      it { expect(assigns(:archive_posts)['2010 10']).not_to be_nil }
      it { expect(assigns(:archive_posts)['2011 11']).not_to be_nil }
      it { expect(assigns(:first_post_year)).not_to be_nil }
    end
  end
end
