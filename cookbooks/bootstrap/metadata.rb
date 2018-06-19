name              'bootstrap'
maintainer        'Keith Beckman'
maintainer_email  'kbeckman@redfournine.com'
description       'Installs/Configures development machine prerequisites.'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url        'https://github.com/kbeckman/beckmanshire-chef'
issues_url        'https://github.com/kbeckman/beckmanshire-chef/issues'

license           'MIT'
version           '0.2.0'
# chef_version      '~> 13'
supports          '>= 10.13'

depends           'homebrew', '~> 4.2.0'
depends           'rvm',      '~> 0.9.4'
