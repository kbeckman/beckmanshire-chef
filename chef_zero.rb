base = File.expand_path('..', __FILE__)

nodes_path                File.join(base, 'nodes')
data_bag_path             File.join(base, 'data_bags' )
encrypted_data_bag_secret File.join(base, 'data_bag_key')

ssl_verify_mode   :verify_peer
chef_zero.enabled true
local_mode        true

cookbook_path []
cookbook_path << File.join(base, 'berks-cookbooks')
