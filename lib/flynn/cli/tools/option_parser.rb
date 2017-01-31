require 'optparse'

module Flynn
	module CLI
		module Tools
			class OptionParser < OptionParser
				@@log_levels = [Logger::INFO, Logger::DEBUG]
				def parse!
					begin
						super
					rescue ::OptionParser::InvalidOption, ::OptionParser::MissingArgument
						puts self
						exit 1
					end
				end
				def add_general_options!
					on "--dry-run", "Prevents this command from making changes" do |v|
						Flynn::CLI::Tools.options[:dry_run] = v
					end
					on "--verbose", "Sets log level to INFO" do
						Flynn::CLI::Tools.logger.level = Logger::INFO
					end
					on "--debug", "Sets log level to DEBUG" do
						Flynn::CLI::Tools.logger.level = Logger::DEBUG
					end
					if File.basename($0).start_with? "flynn-"
						on "-c CLUSTER", "--cluster CLUSTER", String, "Set the flynn cluster to use" do |v|
							Flynn::CLI::Tools.flynn_cluster = v
						end
					end
					on "-q", "--quiet", "Disables logging" do |v|
						Flynn::CLI::Tools.options[:quiet] = v
					end
					on "-h", "--help", "Prints this help" do
						puts self
						exit
					end
				end
			end
		end
	end
end
