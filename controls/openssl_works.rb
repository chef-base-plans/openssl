title 'Tests to confirm openssl works as expected'

plan_name = input('plan_name', value: 'openssl')
plan_ident = "#{ENV['HAB_ORIGIN']}/#{plan_name}"

control 'core-plans-openssl-works' do
  impact 1.0
  title 'Ensure openssl works as expected'
  desc '
  Two main tests are performed here:
  (1) "openssl version" should return the expected version
  (2) "openssl enc -base64" should encode a string successfully
  '
  openssl_path = command("hab pkg path #{plan_ident}")
  describe openssl_path do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
  end
  
  openssl_pkg_ident = ((openssl_path.stdout.strip).match /(?<=pkgs\/)(.*)/)[1]
  describe command("hab pkg exec #{ openssl_pkg_ident} openssl version") do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stdout') { should match /OpenSSL 1.0.2t-fips/ }
    its('stderr') { should be_empty }
  end

  openssl_pkg_ident = ((openssl_path.stdout.strip).match /(?<=pkgs\/)(.*)/)[1]
  describe command("echo 'a_byte_character' | hab pkg exec #{ openssl_pkg_ident} openssl enc -base64") do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stdout') { should match /YV9ieXRlX2NoYXJhY3Rlcgo=/ }
    its('stderr') { should be_empty }
  end
end
