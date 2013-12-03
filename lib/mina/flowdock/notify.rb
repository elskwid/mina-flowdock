# encoding: utf-8

set_default :flowdock_deploy_tags,  []
set_default :flowdock_source,       "Mina deployment"
set_default :flowdock_from_name,    git_user_name
set_default :flowdock_from_address, git_user_email


set_default :flowdock_message_subject,
  "<%= flowdock_project_name %> deployed to #<%= flowdock_deploy_env %>"

set_default :flowdock_message,
  "<%= flowdock_deploy_type %> <%= flowdock_deploy_ref %> (<%= flowdock_deploy_sha %>) was deployed to <%= flowdock_deploy_env %>."

set :flowdock_deploy_tags,
  ["deploy", "#{flowdock_deploy_env}"] + flowdock_deploy_tags

desc "Update configured Flowdock flows after a deployment"
namespace :flowdock do
  task :notify do

    %w(
      flowdock_project_name
      flowdock_api_token
      flowdock_deploy_env
    ).each do |required|
      unless self.send("#{required}?")
        error "Mina Flowdock notifications require '#{required}' to be set."
        exit
      end
    end

    # mina git module uses commit if given
    type, ref = if commit? && !commit.nil?
      ["Commit", commit]
    else
      ["Branch", branch]
    end

    sha = capture("cd #{deploy_to}/scm && git --no-pager show -s -v --format=%H #{ref}").strip

    unless sha
      error "Mina Flowdock notifications couldn't find the configured #{type} [#{ref}] on the server."
      exit
    end

    set :flowdock_deploy_type, type
    set :flowdock_deploy_ref,  ref
    set :flowdock_deploy_sha,  sha

    flows = Array(flowdock_api_token).map do |token|
      Flowdock::Flow.new(
        api_token: token,
        source:    flowdock_source,
        project:   flowdock_project_name,
        from: {
          name:    flowdock_from_name,
          address: flowdock_from_address
        }
      )
    end

    print_local_status "Notify configured Flowdock flows"

    flows.each do |flow|
      print_notification_debug(flow) if verbose_mode?
      next if  simulate_mode?

      flow.push_to_team_inbox(
        format:  "html",
        subject: flowdock_message_subject,
        content: flowdock_message,
        tags:    flowdock_deploy_tags
      )
    end
  end
end
