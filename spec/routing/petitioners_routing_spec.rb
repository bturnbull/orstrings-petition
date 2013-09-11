require 'spec_helper'

describe 'Petitioners Routing' do
  it 'resolves GET /petition/signers' do
    expect(:get => '/petition/signers').to route_to(
      :controller => 'petitioners',
      :action     => 'index')
  end

  it 'resolves GET /petition/signers/:id' do
    expect(:get => '/petition/signers/123').to route_to(
      :controller => 'petitioners',
      :action     => 'show',
      :id         => '123')
  end

  it 'resolves GET /petition/signers/new' do
    expect(:get => '/petition/signers/new').to route_to(
      :controller => 'petitioners',
      :action     => 'new')
  end

  it 'resolves POST /petition/signers' do
    expect(:post => '/petition/signers').to route_to(
      :controller => 'petitioners',
      :action     => 'create')
  end

  it 'does not resolve GET /petition/signers/edit' do
    expect(:get => '/petition/signers/edit').to_not be_routable
  end

  it 'does not resolve PUT /petition/signers/:id' do
    expect(:put => '/petition/signers/update').to_not be_routable
  end

  it 'does not resolve DELETE /petition/signers/:id' do
    expect(:delete => '/petition/signers/123').to_not be_routable
  end
end
