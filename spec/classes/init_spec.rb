require 'spec_helper'
describe 'god' do

  context 'with defaults for all parameters' do
    it { should contain_class('god') }
  end
end
