class GithubInfoController < ApplicationController
  def show
    @repo = GithubRepoFacade.new.repo
  end
end
