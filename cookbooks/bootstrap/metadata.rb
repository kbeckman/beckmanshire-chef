name              'bootstrap'
maintainer        'Keith Beckman'
maintainer_email  'kbeckman@redfournine.com'
description       'Installs/Configures development machine prerequisites.'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url        'https://github.com/kbeckman/beckmanshire-chef'
issues_url        'https://github.com/kbeckman/beckmanshire-chef/issues'

license           'MIT'
version           '0.1.0'
chef_version      '~> 12'
supports          '>= 10.11'

depends           'homebrew', '~> 2.1.2'
depends           'rvm', '~> 0.9.4'
