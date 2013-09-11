require 'spec_helper'

describe 'Petitions Routing' do
  it 'resolves GET /petition' do
    expect(:get => '/petition').to route_to(
      :controller => 'petitions',
      :action     => 'show')
  end
end
