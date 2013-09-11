require 'spec_helper'

describe 'Invites Routing' do
  it 'resolves GET /petition/signers/:signer_id/invites' do
    expect(:get => '/petition/signers/123/invites').to route_to(
      :controller => 'invites',
      :action     => 'index',
      :signer_id  => '123')
  end

  it 'resolves GET /petition/signers/:signer_id/invites/:id' do
    expect(:get => '/petition/signers/123/invites/456').to route_to(
      :controller => 'invites',
      :action     => 'show',
      :signer_id  => '123',
      :id         => '456')
  end

  it 'resolves GET /petition/signers/:signer_id/invites/new' do
    expect(:get => '/petition/signers/123/invites/new').to route_to(
      :controller => 'invites',
      :action     => 'new',
      :signer_id  => '123')
  end

  it 'resolves POST /petition/signers/:signer_id/invites' do
    expect(:post => '/petition/signers/123/invites').to route_to(
      :controller => 'invites',
      :action     => 'create',
      :signer_id  => '123')
  end

  it 'does not resolve GET /petition/signers/:signer_id/invites/:id/edit' do
    expect(:get => '/petition/signers/123/invites/456/edit').to_not be_routable
  end

  it 'does not resolve PUT /petition/signers/:signer_id/invites/:id' do
    expect(:put => '/petition/signers/123/invite/456').to_not be_routable
  end

  it 'does not resolve DELETE /petition/signers/:signer_id/invite/:id' do
    expect(:delete => '/petition/signers/123/invites/456').to_not be_routable
  end
end
