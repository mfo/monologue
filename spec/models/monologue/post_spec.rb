# frozen_string_literal: true
require 'spec_helper'

describe Monologue::Post, type: :model do
  before(:each) do
    @post = Factory(:post)
  end

  it { validate_presence_of(:user_id) }
  it { validate_presence_of(:site_id) }

  it 'is valid with valid attributes' do
    @post.should be_valid
  end

  it { validate_presence_of(:title) }
  it { validate_presence_of(:content) }
  it { validate_presence_of(:published_at) }

  context 'no url provided' do
    it 'creates permalink (url) automatically with title and year' do
      title = 'this is a great title!!!'
      post = Factory(:post, url: '', title: title, published_at: '2012-02-02')
      post.url.should == '2012/this-is-a-great-title'
    end
  end

  it "should not let you create a post with a url starting with a '/'" do
    expect do
      Factory(:post, url: '/whatever')
    end.to raise_error(Mongoid::Errors::Validations)
  end

  it 'validates that URLs are unique to a post' do
    post_1 = Factory(:post, url: 'unique/url')
    expect { post_1.save }.not_to raise_error
    expect do
      Factory(:post, url: 'unique/url')
    end.to raise_error(Mongoid::Errors::Validations)
  end

  it 'excludes the current post revision on URL uniqueness validation' do
    pr = Factory(:post,
                 url: nil,
                 title: 'unique title',
                 published_at: DateTime.new(2011))
    pr.content = 'Something changed'
    pr.save
    pr.url.should == '2011/unique-title'
  end

  describe "post's tags" do
    before do
      @post.tag_list = 'new, tags,here'
      @post.save
      @post.reload
    end

    it 'adds tags to post' do
      @post.tags.size.should eq(3)
    end

    it 'updates with new tags added' do
      @post.tag_list = 'new, tags, here, plus'
      @post.save
      @post.reload.tags.size.should eq(4)
    end

    it 'removes tags that were removed' do
      @post.tag_list = 'new'
      @post.save
      @post.reload.tags.size.should eq(1)
    end
  end
end
