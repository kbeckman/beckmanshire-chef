user_msg = "node['#{cookbook_name}']['user'] must be set!"
raise user_msg if node[cookbook_name]['user'].nil?
raise user_msg if node[cookbook_name]['user'].length == 0
