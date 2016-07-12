# frozen_string_literal: true

#
# Monologue::Admin::SitesController class
#  manage site/domain
#
class Monologue::Admin::SitesController < Monologue::Admin::BaseController
  respond_to :html
  before_action :load_sites, only: [:index]
  before_action :load_site, only: [:edit, :update, :destroy]

  SITE_PER_PAGE = 20

  def index
    @page = params[:page].nil? ? 1 : params[:page]
  end

  def new
    @site = Monologue::Site.new
  end

  def create
    @site = Monologue::Site.new(site_params)
    if @site.save
      prepare_flash_and_redirect_to_edit
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @site.update(site_params)
      prepare_flash_and_redirect_to_edit
    else
      render :edit
    end
  end

  def destroy
    if @site.destroy
      redirect_to admin_sites_path,
                  notice:  I18n.t('monologue.admin.sites.delete.removed')
    else
      redirect_to admin_sites_path,
                  alert: I18n.t('monologue.admin.sites.delete.failed')
    end
  end

  private

  def load_site
    @site = Monologue::Site.find(params[:id])
  end

  def load_sites
    p = params[:page].nil? ? 1 : params[:page].to_i
    @sites = Monologue::Site.order_by([:created_at, :desc])
                            .limit(SITE_PER_PAGE)
                            .offset((p - 1) * SITE_PER_PAGE)
  end

  def prepare_flash_and_redirect_to_edit
    flash[:notice] = I18n.t("monologue.admin.sites.#{params[:action]}.saved")
    redirect_to edit_admin_site_path(@site)
  end

  def site_params
    params.require(:site).permit(:name, :domain, :title, :subtitle, :locale,
                                 :meta_description, :meta_keyword)
  end
end
