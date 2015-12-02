class Monologue::PostsController < Monologue::ApplicationController
  def index
    @page = params[:page].nil? ? 1 : params[:page]
    @posts = Monologue::Post.page(@page).includes(:user).published
  end

  def show
    if monologue_current_user
      @post = Monologue::Post.default.where(url: params[:post_url]).first
    else
      @post = Monologue::Post.published.where(url: params[:post_url]).first
    end
    if @post.nil?
      not_found
    end
  end

  def feed
    @posts = Monologue::Post.published.limit(25)
    if params[:tags].present?
      tags = Monologue::Tag.where(name_downcase: params[:tags].split(",")).pluck(:id)
      @posts = @posts.where(:tag_ids.in => tag_ids)
    end
    render 'feed', layout: false
  end
end
