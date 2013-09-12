require 'spec_helper'

describe 'Welcome Routing' do
  it 'resolves GET /' do
    expect(:get => '/').to route_to(
      :controller => 'welcome',
      :action     => 'index')
  end
end
