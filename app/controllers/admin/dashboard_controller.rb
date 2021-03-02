class Admin::DashboardController < ApplicationController

  def index
    @facade = AdminDashboardFacade.new
  end
end
