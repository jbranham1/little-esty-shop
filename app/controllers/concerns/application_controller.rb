class ApplicationController < ActionController::Base
  # before_action :repo_name,
                # :repo_usernames,
                # :repo_commits,
                # :repo_pull_requests

  def repo_name
    github_service = GithubService.new
    @repo_name = github_service.get_data("")[:name]
  end

  def repo_usernames
    github_service = GithubService.new
    @repo_usernames = github_service.usernames.map do |key, value|
      key[:login]
    end.uniq[0..2]
  end

  def repo_commits
    github_service = GithubService.new
    @repo_commits = @repo_usernames.each_with_object({}) do |username, commits|
      commits[username] = github_service.commits(username).count
    end
  end

  def repo_pull_requests
    github_service = GithubService.new
    @repo_prs = github_service.pull_requests.count
  end
end
