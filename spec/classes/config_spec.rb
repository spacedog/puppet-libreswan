require 'spec_helper'

describe 'libreswan::config' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "libreswan::config class without any parameters" do
          it do 
            expect { should compile.with_all_deps }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
          end
        end
        context "libreswan::config class with parameters" do
          let (:params) do
            {
              'ensure'          => 'present',
              'config'          => '/etc/ipsec.conf',
              'configdir'       => '/etc/ipsec.d',
              'config_secrets'  => '/etc/ipsec.secrets',
              'ipsec_config'    => {
                'key' => 'value',
              },
              'purge_configdir' => false,
            }
          end
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_file('/etc/ipsec.secrets').with_ensure('present') }
          it { is_expected.to contain_file('/etc/ipsec.secrets').with_content("include /etc/ipsec.d/*.secret\n") }
          it { is_expected.to contain_file('/etc/ipsec.d').with_ensure('directory') }
          it { is_expected.to contain_concat('/etc/ipsec.conf').with_ensure('present') }
          it do 
            is_expected.to contain_concat_fragment('/etc/ipsec.conf_setup').with({
              'target'  => '/etc/ipsec.conf',
              'content' => "\n\nconfig setup\n  key=value\n\n",
            })
          end
          it do 
            is_expected.to contain_concat_fragment('/etc/ipsec.conf_HEADER').with({
              'target'  => '/etc/ipsec.conf',
              'content' => '# File is managed by puppet\n',
            })
          end
          it do 
            is_expected.to contain_concat_fragment('/etc/ipsec.conf_FOOTER').with({
              'target'  => '/etc/ipsec.conf',
              'content' => "include /etc/ipsec.d/*.conf\n",
            })
          end
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'libreswan::config class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end
      it do 
        expect { should compile.with_all_deps }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
      end
    end
  end
end
