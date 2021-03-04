class ApplicationController < ActionController::Base
#ßbefore_action :git_repo

  def git_repo
    @repo = GitRepository.new
  end
end
