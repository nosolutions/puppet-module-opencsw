require 'spec_helper'

describe 'opencsw', :type => :class do
  context "On a Solaris server" do
    let :facts do
      { :osfamily => 'Solaris',
        :zonename => 'global',
      }
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

    it { should contain_class('staging::file').that_comes_before('Package[CSWpkgutil')}
    it { should contain_file('/var/sadm/install/admin/opencsw-noask').that_comes_before('Package[CSWpkgutil')}

    it do
    should contain_class('staging::file').with({
        'target' => '/var/sadm/pkg/CSWpkgutil.pkg',
        'source' => 'http://sunkist6.eb.lan.at/osscsw/pkgutil.pkg',
        'before' => 
        })
    end

    it do
    should contain_file('/var/sadm/install/admin/opencsw-noask').with({
        'ensure' => 'latest',
        'provider' => 'sun',
        'source' => '/var/sadm/pkg/CSWpkgutil.pkg',
        'adminfile' => '/var/sadm/install/admin/opencsw-noask',
        })

    it do
    should contain_package('CSWpkgutil').with({
        'ensure' => 'CSWpkgutil.pkg',
        'content' => 
        })
    # it do
    # should contain_exec('run_script').with({
    #     'command'   => '/opt/sysdoc_serialnumber_brandedzones.sh',
    #     'creates'   => '/opt/sysdoc_serialnumber.lock',

    #  })
    # end
    it do 
    should contain_file("/opt/sysdoc_serialnumber_brandedzones.sh").with({
        'ensure'    => 'present',
        'source'    => 'puppet:///modules/oss_operations/sysdoc_serialnumber_brandedzones.sh',
        'mode'      => '0700',
        'owner'     => 'root',
        'group'     => 'root',
        })
    end
    it do 
    should contain_file("/opt/sysdoc_serialnumber.lock").with({
        'ensure'    => 'present',
        'mode'      => '0700',
        'owner'     => 'root',
        'group'     => 'root',
        })
    end
  end
end
