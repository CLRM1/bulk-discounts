class GithubRepoFacade
  def repo_name
    GithubRepo.new(service.repo_data)
  end

  def commits
    service.total_commits
  end

  def usernames
    GithubRepo.new(service.get_usernames)
  end

  def service
    GithubRepoService.new
  end
end
