class GithubRepoFacade
  def repo
    GithubRepo.new(service.repo_data)
  end

  def service
    GithubRepoService.new
  end
end
