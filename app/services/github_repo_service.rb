class GithubRepoService
  def repo_data
    get_url("https://api.github.com/repos/B-gann21/little-esty-shop")
  end

  def total_commits
    page_1 = get_url("https://api.github.com/repos/B-gann21/little-esty-shop/commits?q=addClass+user:mozilla&per_page=100&page=1")
    page_2 = get_url("https://api.github.com/repos/B-gann21/little-esty-shop/commits?q=addClass+user:mozilla&per_page=100&page=2")
    page_3 = get_url("https://api.github.com/repos/B-gann21/little-esty-shop/commits?q=addClass+user:mozilla&per_page=100&page=3")
    page_1.count + page_2.count + page_3.count
  end

  def total_pr
    pull_requests = get_url("https://api.github.com/repos/B-gann21/little-esty-shop/pulls?state=all&per_page=100")
    pull_requests.count
  end

  def get_usernames
    get_url("https://api.github.com/repos/B-gann21/little-esty-shop/contributors")
  end

  def get_url(url)
    response = HTTParty.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end
end
