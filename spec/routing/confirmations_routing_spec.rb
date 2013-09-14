require 'spec_helper'

describe 'Confirmations Routing' do

  it 'resolves GET /petition/confs/:id' do
    expect(:get => '/petition/confs/04eafcfaff6601973a33df5861e14d53').to route_to(
      :controller => 'confirmations',
      :action     => 'show',
      :id         => '04eafcfaff6601973a33df5861e14d53')
  end

  it 'does not resolve GET /petition/confs' do
    expect(:get => '/petition/confs').to_not be_routable
  end

  it 'does not resolve GET /petition/confs/new' do
    expect(:get => '/petition/confs/new').to_not be_routable
  end

  it 'does not resolve POST /petition/confs' do
    expect(:post => '/petition/confs').to_not be_routable
  end

  it 'does not resolve GET /petition/confs/:id/edit' do
    expect(:get => '/petition/confs/04eafcfaff6601973a33df5861e14d53/edit').to_not be_routable
  end

  it 'does not resolve PUT /petition/confs/:id' do
    expect(:put => '/petition/confs/04eafcfaff6601973a33df5861e14d53').to_not be_routable
  end

  it 'does not resolve DELETE /petition/confs/:id' do
    expect(:delete => '/petition/confs/04eafcfaff6601973a33df5861e14d53').to_not be_routable
  end
end
