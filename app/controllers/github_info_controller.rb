class GithubInfoController < ApplicationController
  def show
    @repo = GithubRepoFacade.new.repo_name
    @commits = GithubRepoFacade.new.commits
    @usernames = GithubRepoFacade.new.usernames
    # require 'pry'; binding.pry
  end
end
