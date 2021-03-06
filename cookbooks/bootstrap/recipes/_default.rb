user_msg = "node['#{cookbook_name}']['user'] must be set!"
raise user_msg if node[cookbook_name]['user'].nil?
raise user_msg if node[cookbook_name]['user'].empty?

castle_msg = "node['#{cookbook_name}']['homesick']['castle_name'] must be set!"
raise castle_msg if node[cookbook_name]['homesick']['castle_name'].nil?
raise castle_msg if node[cookbook_name]['homesick']['castle_name'].empty?

repo_msg = "node['#{cookbook_name}']['homesick']['github_repo'] must be set!"
raise repo_msg if node[cookbook_name]['homesick']['github_repo'].nil?
raise repo_msg if node[cookbook_name]['homesick']['github_repo'].empty?
