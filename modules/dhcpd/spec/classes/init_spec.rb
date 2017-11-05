require 'spec_helper'
describe 'dhcpd' do
  context 'with default values for all parameters' do
    it { should contain_class('dhcpd') }
  end
end
