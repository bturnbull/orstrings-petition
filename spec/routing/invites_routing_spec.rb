require 'spec_helper'

describe 'Invites Routing' do
  it 'resolves GET /petition/invites/:id' do
    expect(:get => '/petition/invites/04eafcfaff6601973a33df5861e14d53').to route_to(
      :controller => 'invites',
      :action     => 'show',
      :id         => '04eafcfaff6601973a33df5861e14d53')
  end

  it 'does not resolve GET /petition/invites' do
    expect(:get => '/petition/invites').to_not be_routable
  end

  it 'does not resolve GET /petition/invites/new' do
    expect(:get => '/petition/invites/new').to_not be_routable
  end

  it 'does not resolve POST /petition/invites' do
    expect(:post => '/petition/invites').to_not be_routable
  end

  it 'does not resolve GET /petition/invites/:id/edit' do
    expect(:get => '/petition/invites/04eafcfaff6601973a33df5861e14d53/edit').to_not be_routable
  end

  it 'does not resolve PUT /petition/invites/:id' do
    expect(:put => '/petition/invites/04eafcfaff6601973a33df5861e14d53').to_not be_routable
  end

  it 'does not resolve DELETE /petition/signers/:signer_id/invite/:id' do
    expect(:delete => '/petition/invites/04eafcfaff6601973a33df5861e14d53').to_not be_routable
  end
end
