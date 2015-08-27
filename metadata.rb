# rubocop:disable Style/SingleSpaceBeforeFirstArg
name             'qa-chef-server-cluster'
maintainer       'Patrick Wright'
maintainer_email 'patrick@chef.io'
license          'all_rights'
description      'Installs/Configures QA clusters'
version          '2.1.1'

depends 'chef-ingredient'
depends 'omnibus-artifactory-artifact'
depends 'lvm'
depends 'apt'
depends 'build-essential'
depends 'packagecloud'
# rubocop:enable Style/SingleSpaceBeforeFirstArg
