title 'Tests to confirm openssl exists'

plan_name = input('plan_name', value: 'openssl')
plan_ident = "#{ENV['HAB_ORIGIN']}/#{plan_name}"
openssl_relative_path = input('command_path', value: '/bin/openssl')
openssl_installation_directory = command("hab pkg path #{plan_ident}")
openssl_full_path = openssl_installation_directory.stdout.strip + "#{ openssl_relative_path}"
 
control 'core-plans-openssl-exists' do
  impact 1.0
  title 'Ensure openssl exists'
  desc '
  '
   describe file(openssl_full_path) do
    it { should exist }
  end
end
