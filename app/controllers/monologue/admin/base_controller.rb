class Monologue::Admin::BaseController < Monologue::ApplicationController
  include Monologue::ControllerHelpers::Auth

  # TODO: find a way to test that with capybara
  force_ssl if Monologue::Config.admin_force_ssl

  layout 'layouts/monologue/admin'
end
