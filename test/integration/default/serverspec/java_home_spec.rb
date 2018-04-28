require 'serverspec'

set :backend, :exec

describe command("echo $JAVA_HOME") do
  its(:stdout) { should match '/opt/oracle/jre8' }
end

describe file('/opt/oracle/jre8') do
  it { should be_symlink }
  it { should exist }
end

describe file('/opt/oracle/jre10') do
  it { should be_symlink }
  it { should exist }
end
