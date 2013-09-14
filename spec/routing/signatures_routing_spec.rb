require 'spec_helper'

describe 'Signatures Routing' do
  it 'resolves GET /petition/signatures' do
    expect(:get => '/petition/signatures').to route_to(
      :controller => 'signatures',
      :action     => 'index')
  end

  it 'resolves GET /petition/signatures/:id' do
    expect(:get => '/petition/signatures/123').to route_to(
      :controller => 'signatures',
      :action     => 'show',
      :id         => '123')
  end

  it 'resolves GET /petition/signatures/new' do
    expect(:get => '/petition/signatures/new').to route_to(
      :controller => 'signatures',
      :action     => 'new')
  end

  it 'resolves POST /petition/signatures' do
    expect(:post => '/petition/signatures').to route_to(
      :controller => 'signatures',
      :action     => 'create')
  end

  it 'does not resolve GET /petition/signatures/edit' do
    expect(:get => '/petition/signatures/edit').to_not be_routable
  end

  it 'does not resolve PUT /petition/signatures/:id' do
    expect(:put => '/petition/signatures/update').to_not be_routable
  end

  it 'does not resolve DELETE /petition/signatures/:id' do
    expect(:delete => '/petition/signatures/123').to_not be_routable
  end
end
