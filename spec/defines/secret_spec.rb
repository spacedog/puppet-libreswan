require 'spec_helper'

describe 'libreswan::secret', type: :define do
  let(:title) { 'conn1' }
  let(:pre_condition) { 'include libreswan' }

  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'libreswan::secret define without any parameters' do
          it do
            expect { is_expected.to compile.with_all_deps }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
          end
        end
        [ 'PSK', 'XAUTH', 'RSA' ].each do |type|
          context "libreswan::secret define with type #{type}" do
            let(:params) do
              {
                'id'     => 'testid',
                'ensure' => 'present',
                'secret' => 'passphrase',
                'type'   => type.to_s,
              }
            end

            it { is_expected.to contain_class('libreswan') }
            it { is_expected.to compile.with_all_deps }
            it do
              is_expected.to contain_file('/etc/ipsec.d/conn1.secret').with({
                                                                              'ensure' => 'present',
                'owner'   => 'root',
                'group'   => 'root',
                'mode'    => '0400',
                'content' => "testid : #{type} \"passphrase\"\n",
                                                                            })
            end
          end
        end
        context 'libreswan::secret define with secret as hash' do
          let(:params) do
            {
              'id'     => 'testid',
              'ensure' => 'present',
              'type'   => 'RSA',
              'secret' => {
                'key1' => 'value1',
                'key2' => 'value2',
              },
            }
          end

          it { is_expected.to compile.with_all_deps }
          it do
            is_expected.to contain_file('/etc/ipsec.d/conn1.secret').with({
                                                                            'ensure' => 'present',
              'owner'   => 'root',
              'group'   => 'root',
              'mode'    => '0400',
              'content' => "testid : RSA {\n  key1: value1\n  key2: value2\n}\n",
                                                                          })
          end
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'libreswan::secret class without any parameters on Solaris/Nexenta' do
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
