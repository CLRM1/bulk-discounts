class GithubInfoController < ApplicationController
  def show
    @repo = GithubRepoFacade.new.repo_name
    @commits = GithubRepoFacade.new.commits
  end
end
