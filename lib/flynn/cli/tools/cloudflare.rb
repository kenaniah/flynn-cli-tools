require 'httparty'
require 'json'

['CLOUDFLARE_EMAIL', 'CLOUDFLARE_KEY', 'CLOUDFLARE_ZONE'].each do |v|
	unless ENV[v]
		puts "Please define the #{v} environment variable"
		exit 1
	end
end

module Flynn
	module CLI
		module Tools
			class CloudFlare
				include HTTParty
				base_uri 'https://api.cloudflare.com/client/v4'

				# Default headers
				headers({
					"X-Auth-Email": ENV['CLOUDFLARE_EMAIL'],
					"X-Auth-Key": ENV['CLOUDFLARE_KEY'],
					"Content-Type": "application/json"
				})

				# Override common methods
				class << self
					[:get, :post, :delete].each do |m|

						alias_method :"_#{m}", m

						# Override the base method
						define_method m do |*args|
							resp = self.send :"raw_#{m}", *args
							unless resp["success"]
								Flynn::CLI::Tools.logger.error "Request failed: #{resp["errors"]}"
								exit 2
							end
							resp["result"]
						end

						# Define a raw version
						define_method :"raw_#{m}" do |*args|
							Flynn::CLI::Tools.logger.info "#{m.upcase} #{base_uri}#{args[0]}"
							JSON.parse(self.send(:"_#{m}", *args).body)
						end

					end
				end

				# Pulls the zone identifier for our domain
				def self.zone_identifier
					@zone_identifier ||= self.get("/zones?name=#{ENV['CLOUDFLARE_ZONE']}")[0]["id"]
				end

			end
		end
	end
end
