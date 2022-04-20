require 'rails_helper'

RSpec.describe GithubRepoFacade do
 context 'instance methods' do
    it '.repo can create a GitHubRepo' do
      facade = GithubRepoFacade.new
      repo = facade.repo_name

      expect(repo).to be_a(GithubRepo)
    end

    it '.service can create a GithubRepoService' do
      facade = GithubRepoFacade.new
      service = facade.service

      expect(service).to be_a(GithubRepoService)
    end
  end
end
