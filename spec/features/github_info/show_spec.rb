require 'rails_helper'

RSpec.describe 'the Github Info page' do
  it 'should have the name of our repo' do
    visit '/github_info'

    expect(page).to have_content('B-gann21/little-esty-shop')
  end

  it 'should have the # of commits' do
    commit_count = GithubRepoService.new.total_commits
    visit '/github_info'

    expect(page).to have_content("Commits: #{commit_count}")
  end

  it 'should have the # of pull requests' do
    pr_count = GithubRepoService.new.total_pr
    visit '/github_info'
    save_and_open_page

    expect(page).to have_content("#{pr_count}")
  end
end
