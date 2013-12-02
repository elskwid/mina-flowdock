%w(flowdock grit mina/hooks).each do |lib|
  begin
    require lib
  rescue LoadError => e
    warn e.message
    warn "Mina Flowdock notifications require '#{lib}' to be installed."
    exit -1
  end
end

module Mina
  module Flowdock
    module Plugin
      def flowdock_message_subject
        erb_string(settings.send :flowdock_message_subject)
      end

      def flowdock_message
        erb_string(settings.send :flowdock_message)
      end

      def git_config
        Grit::Config.new(Grit::Repo.new("."))
      end

      def erb_string(string, b = binding)
        require "erb"
        erb = ERB.new(string)
        erb.result b
      end

      def print_notification_debug(flow)
        flow = "flow: #{flow.api_token} [#{flow.project}]"
        subj = "subject: #{flowdock_message_subject}"
        msg  = "message: #{flowdock_message}"

        [flow, subj, msg].each do |debug|
            print_local_debug(debug)
        end
      end

      def print_local_debug(msg)
        puts "       #{color(">>", 32)} #{color(msg, 32)}"
      end

      unless defined?(:print_local_status)
        # Prints a status message. (`<-----`)
        def print_local_status(msg)
          puts ""  if verbose_mode?
          puts "#{color('<-----', 32)} #{msg}"
        end
      end
    end # Plugin
  end # Flowdock
end # Mina
