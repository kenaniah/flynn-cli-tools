require_relative 'tools/commander_setup'
require_relative 'tools/logger'
require_relative 'tools/option_parser'

# Ensure tools are present
if `which aws`.empty?
	raise RuntimeError, "aws executable could not be found on $PATH. Try running `brew install awscli`."
end
if `which flynn`.empty?
	raise RuntimeError, "flynn executable could not be found on $PATH. See https://flynn.io/docs/cli#installation."
end

module Flynn
	module CLI
		module Tools

			class << self
				attr_accessor :options
				attr_accessor :logger
			end

			# Intialization
			self.logger = Logger.new STDERR
			logger.level = Logger::WARN
			logger.formatter = proc do |severity, datetime, progname, msg|
				date_format = datetime.strftime("%Y-%m-%d %H:%M:%S")
				"[#{date_format}] #{severity}: #{msg}\n"
			end

			# Options initialization
			self.options = {
				remote: "flynn",
				quiet: false,
				dry_run: false
			}

			def self.flynn_cluster
				@cluster ||= self.capture "flynn cluster default | tail -n 1 | awk '{print $1}'"
			end

			def self.flynn_cluster= cluster
				@cluster = cluster
			end

			def self.app_env
				@app_env ||= self.capture "cat .flynn-env | grep RAILS_ENV | cut -f 2 -d ="
			end

			def self.app_env= app
				@app_env = app
			end

			def self.flynn_images version = nil

				# Return the full list of images when not asking for a specific version
				images = self._flynn_images
				return images unless version

				# Return the image that matches when a specific version is given
				images.each do |img|
					return [img] if img[:flynn_version] <= version
				end

			end

			def self._flynn_images

				# Short-circuit
				return @images if @images

				# Load from source
				require 'json'
				require 'httparty'
				res = JSON.parse HTTParty.get("https://dl.flynn.io/ec2/images.json").body

				# Find only the ones that are for the current region
				@images = []
				res["versions"].each do |version|
					image = version["images"].select{|img| img["region"] == self.aws_region}[0]
					@images.push({
						flynn_version: version["version"],
						region: image["region"],
						image: image["id"],
						name: image["name"]
					})
				end

				# Return it
				@images

			end

			def self.latest_version
				res = JSON.parse HTTParty.get("https://api.github.com/repos/flynn/flynn/tags").body
				res[0]["name"].strip
			end

			def self.generate_cloud_config

				# Build a discovery URL
				discovery_url = "https://discovery.flynn.io" + `curl -X POST https://discovery.flynn.io/clusters -D - -s | grep Location | awk '{print $2}'`
				version = self.latest_version

				# Return the cloud config
				<<~EOF
					#!/bin/bash

					sudo apt update
					sudo apt-get -o Dpkg::Options::="--force-confnew" upgrade -y

					export FLYNN_VERSION=#{version}
					sudo FLYNN_VERSION=#{version} bash < <(curl -fsSL https://dl.flynn.io/install-flynn)
					sudo flynn-host init --discovery #{discovery_url}

					systemctl enable flynn-host.service
					sudo systemctl start flynn-host

					sudo zpool set autoexpand=on flynn-default
					sudo truncate -s 80g /var/lib/flynn/volumes/zfs/vdev/flynn-default-zpool.vdev
					sudo zpool online -e flynn-default /var/lib/flynn/volumes/zfs/vdev/flynn-default-zpool.vdev

					init 6
				EOF

			end

			def self.aws_region
				@region ||= self.capture "aws configure get region"
			end

			def self.system! *args
				self.system *args, allow_dry: false
			end

			def self.system *args, allow_dry: true
				dry = allow_dry && options[:dry_run]
				logger.debug "#{dry ? 'Dry ' : ''}Running: #{args.join " "}" unless options[:quiet]
				super *args unless dry
			end

			def self.capture command
				logger.debug "Running: #{command}" unless options[:quiet]
				`#{command}`.strip
			end

			def self.exit_if_failed
				exit $?.exitstatus unless $?.success?
			end

		end
	end
end
