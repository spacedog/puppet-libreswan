require 'spec_helper'

describe 'libreswan::conn', :type => :define do
  let(:title) { 'conn1' }
  let(:pre_condition) { 'include libreswan' }
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "libreswan::conn define without any parameters" do
          it do 
            expect { should compile.with_all_deps }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
          end
        end
        context "libreswan::conn define with parameters" do
          let (:params) do
            {
              'ensure' => 'present',
              'options' => {
                'key1'  => 'value1',
                'key2'  => 'value2',
              }
            }
          end
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('libreswan') }
          it do 
            is_expected.to contain_file('/etc/ipsec.d/conn1.conf').with({
            'ensure'  => 'present',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0400',
            'content' => "\nconn conn1\n  key1=value1\n  key2=value2\n\n",
          })
          end
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'libreswan::define define without any parameters on Solaris/Nexenta' do
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
