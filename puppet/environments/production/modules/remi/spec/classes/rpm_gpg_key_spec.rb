require 'spec_helper'
describe 'remi::rpm_gpg_key' do

  context 'with default values for all parameters' do
    it { should compile }
    it { should compile.with_all_deps }
    it { should contain_class('remi::rpm_gpg_key') }

    it { should contain_file('/etc/pki/rpm-gpg/RPM-GPG-KEY-remi').with_ensure('present') }
    it { should contain_exec('import-remi').with_command('rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-remi') }
  end

  context 'with absent' do
    let(:params) do
      {
        ensure: 'absent',
      }
    end

    it { should contain_file('/etc/pki/rpm-gpg/RPM-GPG-KEY-remi').with_ensure('absent') }
  end
end
