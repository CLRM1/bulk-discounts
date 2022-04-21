class GithubInfoController < ApplicationController
  def show
    @repo = GithubRepoFacade.new.repo_name
    @commits = GithubRepoFacade.new.commits
    @usernames = GithubRepoFacade.new.usernames
    @pull_requests = GithubRepoFacade.new.pull_requests
    # require 'pry'; binding.pry
  end
end
