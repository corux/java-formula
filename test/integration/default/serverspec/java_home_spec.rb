require 'serverspec'

set :backend, :exec

describe command("echo $JAVA_HOME") do
  its(:stdout) { should match '/opt/oracle/jre8' }
end

describe file('/opt/oracle/jre8') do
  it { should be_symlink }
  it { should exist }
end

describe file('/opt/oracle/jre11') do
  it { should be_symlink }
  it { should exist }
end

describe file('/opt/oracle/jre12') do
  it { should be_symlink }
  it { should exist }
end

describe file('/opt/oracle/jre13') do
  it { should be_symlink }
  it { should exist }
end
