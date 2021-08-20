require 'spec_helper'

describe 'libreswan::service' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'libreswan::service class without any parameters' do
          it do
            expect { is_expected.to compile.with_all_deps }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
          end
        end
        context 'libreswan::service class with parameters' do
          let(:params) do
            {
              'service_name'   => 'ipsec',
              'service_ensure' => 'running',
              'service_enable' => true,
            }
          end

          it { is_expected.to compile.with_all_deps }
          it do
            is_expected.to contain_service('ipsec').with({
                                                           'ensure' => 'running',
            'enable' => true,
                                                         })
          end
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'libreswan::service class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          osfamily: 'Solaris',
          operatingsystem: 'Nexenta',
        }
      end

      it do
        expect { is_expected.to compile.with_all_deps }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
      end
    end
  end
end
