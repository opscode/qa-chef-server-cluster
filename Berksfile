source "https://supermarket.getchef.com"

metadata

cookbook 'chef-vault'
cookbook 'apt'
cookbook 'chef-server-ingredient', github: 'opscode-cookbooks/chef-server-ingredient'
cookbook 'chef-server-cluster', github: 'opscode-cookbooks/chef-server-cluster'
cookbook 'lvm'
cookbook 'omnibus-artifactory-artifact', git: 'git@github.com:opscode-cookbooks/omnibus-artifactory-artifact.git', branch: '0.3.0'

def fixture(name)
  cookbook "#{name}", path: "test/fixtures/cookbooks/#{name}"
end

group :integration do
  fixture 'standalone_server'
end

