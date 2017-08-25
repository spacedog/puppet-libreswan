require 'spec_helper'

describe 'libreswan' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "libreswan class without any parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('libreswan::params') }
          it { is_expected.to contain_class('libreswan::install') }
          it { is_expected.to contain_class('libreswan::config').that_requires('Class[libreswan::install]') }
          it { is_expected.to contain_class('libreswan::service').that_subscribes_to('Class[libreswan::config]') }
        end
        context "libreswan class with manage_service = false" do
          let (:params) do
            {
              'manage_service' => false,
            }
          end
          it { is_expected.to compile.with_all_deps }
          it { is_expected.not_to contain_class('libreswan::service').that_subscribes_to('Class[libreswan::config]') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'libreswan class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end

      it { expect { is_expected.to contain_package('libreswan') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
