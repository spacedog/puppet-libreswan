require 'spec_helper'

describe 'libreswan::install' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'libreswan::install class without any parameters' do
          it do
            expect { is_expected.to compile.with_all_deps }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
          end
        end
        context 'libreswan::install class with parameters' do
          let(:params) do
            {
              'package_ensure' => 'installed',
              'package_name'   => 'libreswan',
            }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_package('libreswan').with_ensure('installed') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'libreswan::install class without any parameters on Solaris/Nexenta' do
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
