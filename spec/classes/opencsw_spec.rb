require 'spec_helper'

describe 'opencsw', :type => :class do
  context "On a Solaris server" do
    let :facts do
      { :osfamily => 'Solaris',
        :zonename => 'global',
      }
    end
    let :params do
      {
        :package_source => 'http://sunkist6.eb.lan.at/osscsw/pkgutil.pkg',
        :mirror         => ['http://sunkist6.eb.lan.at/opencsw/testing', 'http://sunkist6.eb.lan.at/osscsw'],
        :pkgaddopts     => '-G',
        :wgetopts       => '-nv',
        :use_gpg        => 'false',
        :use_md5        => 'false',
      }
    end

    it do
    should contain_define('staging::file[CSWpkgutil.pkg]').that_comes_before('Package[CSWpkgutil]').with({
        'target' => '/var/sadm/pkg/CSWpkgutil.pkg',
        'source' => 'http://sunkist6.eb.lan.at/osscsw/pkgutil.pkg',
        })
    end

    it do
    should contain_file('/var/sadm/install/admin/opencsw-noask').that_comes_before('Package[CSWpkgutil]').with({
        'ensure' => 'file',
        'source' => 'puppet:///modules/opencsw/opencsw-noask',
        })
    end

    # it { should contain_class('staging') }
    it do
    should contain_package('CSWpkgutil').with({
        'ensure'    => 'latest',
        'provider'  => 'sun',
        'source'    => '/var/sadm/pkg/CSWpkgutil.pkg',
        'adminfile' => '/var/sadm/install/admin/opencsw-noask',
        })
    end

    it do
    should contain_file('/etc/opt/csw/pkgutil.conf').that_requires('Package[CSWpkgutil]').with({
        'ensure' => 'symlink',
        'target' => '/etc/opt/csw/pkgutil.conf', 
        })
    end

    it do
    should contain_exec('pkgutil-update').that_requires('File[/etc/opt/csw/pkgutil.conf]').with({
        'command' => '/opt/csw/bin/pkgutil -U',
        'creates' => '/var/opt/csw/pkgutil/'
        })

  end
end

# it { should contain_class('staging::file').that_comes_before('Package[CSWpkgutil')}
# it { should contain_file('/var/sadm/install/admin/opencsw-noask').that_comes_before('Package[CSWpkgutil')}
    