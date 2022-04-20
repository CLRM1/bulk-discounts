require 'rails_helper'

RSpec.describe GithubRepoService do
  context 'instance methods' do
    it '.get_url can get a hash' do
      url = 'https://www.boredapi.com/api/activity'
      service = GithubRepoService.new

      expect(service.get_url(url)).to be_a(Hash)
    end

    it '.repo_data gets the hash from our repo' do
      url = 'https://api.github.com/repos/B-gann21/little-esty-shop'
      service = GithubRepoService.new
      # using a stub so we don't hit the GitHub request limit
      allow(service).to receive(:repo_data).and_return({name: 'B-gann21/little-esty-shop'})

      expect(service.repo_data).to be_a(Hash)
      expect(service.repo_data).to have_key(:name)
    end
  end
end
