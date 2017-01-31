require 'logger'

module Flynn
	module CLI
		module Tools
			class Logger < Logger
				def debug msg
					super unless Flynn::CLI::Tools.options[:quiet]
				end
				def info msg
					super unless Flynn::CLI::Tools.options[:quiet]
				end
				def warn msg
					super unless Flynn::CLI::Tools.options[:quiet]
				end
			end
		end
	end
end
