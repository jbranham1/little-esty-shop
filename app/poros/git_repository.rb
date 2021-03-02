class GitRepository
    attr_reader :repo_name,
                :repo_commits,
                :repo_pull_requests

  def initialize ()
    @github_service = GithubService.new
    @repo_name = repo_name
    @repo_usernames = repo_usernames
    @repo_commits = repo_commits
    @repo_pull_requests = repo_pull_requests
  end

  def repo_name
    @github_service.get_data("")[:name]
  end

  def repo_usernames
    @github_service.usernames.map do |key, value|
      key[:login]
    end.uniq[0..2]
  end

  def repo_commits
     @repo_usernames.each_with_object({}) do |username, commits|
      commits[username] = @github_service.commits(username).count
    end
  end

  def repo_pull_requests
     @github_service.pull_requests.count
  end
end
