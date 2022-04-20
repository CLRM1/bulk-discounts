require 'rails_helper'

RSpec.describe 'the Github Info page' do
  it 'should have the name of our repo' do
    visit '/github_info'

    expect(page).to have_content('B-gann21/little-esty-shop')
  end
end
