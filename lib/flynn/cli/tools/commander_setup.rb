# Provides defaults for programs that use commander
require_relative 'version'
module Flynn
	module CLI
		module Tools
			module CommanderSetup
				def self.included mod
					mod.class_exec do
						program :version, Flynn::CLI::Tools::VERSION
						default_command :help

						global_option "--dry-run", "Prevents this command from making changes" do |v|
							Flynn::CLI::Tools.options[:dry_run] = v
						end
						global_option "--verbose", "Sets log level to INFO" do |v|
							Flynn::CLI::Tools.logger.level = Logger::INFO
						end
						global_option "--debug", "Sets log level to DEBUG" do |v|
							Flynn::CLI::Tools.logger.level = Logger::DEBUG
						end
						if File.basename($0).start_with? "flynn-"
							global_option "-c CLUSTER", "--cluster CLUSTER", String, "Set the flynn cluster to use" do |v|
								Flynn::CLI::Tools.flynn_cluster = v
							end
						end
						global_option "-q", "--quiet", "Disables logging" do |v|
							Flynn::CLI::Tools.options[:quiet] = v
						end
					end
				end
			end
		end
	end
end
