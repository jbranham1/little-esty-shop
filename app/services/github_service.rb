class GithubService

  def get_data(arg)
    response = Faraday.get("https://api.github.com/repos/Gvieve/little-esty-shop#{arg}")
    data = response.body
    json = JSON.parse(data, symbolize_names: true)
  end

  def usernames
    get_data("/contributors")
  end

  def commits(username)
    get_data("/commits?author=#{username}&per_page=100")
  end

  def pull_requests
    get_data("/pulls?state=closed")
  end
end
