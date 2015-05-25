node[:deploy].each do |application, deploy|

  chef_gem "slackr" do
    version '0.0.5'
    action :install
    # removing compile_time warnings in Chef 12 per:
    # http://jtimberman.housepub.org/blog/2015/03/20/chef-gem-compile-time-compatibility/
    compile_time true if Chef::Resource::ChefGem.instance_methods(false).include?(:compile_time)
  end
  
  ruby_block "say_something" do
    block do
       require 'slackr'
  
       slack = Slackr.connect(node[:slack][:team],node[:slack][:api_key])
       slack_options = {
         channel: node[:slack][:channel],
         username: node[:slack][:username],
         icon_url: node[:slack][:icon_url],
         icon_emoji: node[:slack][:icon_emoji]
       }
  
       slack.say("Gising!", slack_options)
    end
    only_if {!node[:slack].nil?}
  end


end
