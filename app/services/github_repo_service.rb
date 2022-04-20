class GithubRepoService
  def repo_data
    get_url("https://api.github.com/repos/B-gann21/little-esty-shop")
  end

  def get_url(url)
    response = HTTParty.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end
end
