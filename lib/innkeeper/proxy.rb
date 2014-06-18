require 'ipaddr'

module Innkeeper
	class Proxy
		include ::Innkeeper::Rack::Mixin
		extend ::Forwardable

		attr_reader :domain, :host_domain, :subdomain
		attr_accessor :manager

		def_delegators :manager, :env, :config

		def initialize(manager)
			@manager = manager
			@halted = false

			unless is_ip_address?(request.host)
				domain_parts = request.host.split('.')

				if domain_parts.size > 2
					@subdomain = domain_parts.shift
				end

				@host_domain = domain_parts.join('.')
				@domain = request.host
			end

			if respond_to?(:find_by_environment)
				_tenant = send(:find_by_environment, subdomain, host_domain, request)
				halt! unless _tenant
				send("tenant=", _tenant)
			end
		end

		def tenant
			@_tenant ||= session_serializer.fetch
		end

		def tenant=(obj)
			return unless obj
			@_tenant = session_serializer.store(obj)
		end

		def session_serializer
			@_session_serializer ||= ::Innkeeper::SessionSerializer.new(self)
		end

		def halted?
			@halted
		end

		def skip!
			manager.app.call(env)
			nil
		end

		def fail!
			halt!

			if config.require_infer && config.redirect_on_failure
				if config.redirect_on_failure == :host_domain
					return redirect! "//#{host_domain}"
				elsif config.redirect_on_failure == :host_domain_with_www
					return redirect! "//www.#{host_domain}"
				elsif config.redirect_on_failure == :failure_app && config.failure_app.respond_to?(:call)
					return config.failure_app.call(request)
				elsif config.redirect_on_failure.is_a? String
					return redirect! "#{config.redirect_on_failure}"
				end	
			end

			manager.app.call(env)
		end

		def halt!
			@halted = true
		end

		private
		def redirect!(uri, code = 302)
			[code, { 'Location' => "#{uri}" }, []]
		end

		def is_ip_address?(host)
			begin
				IPAddr.new host
				return true
			rescue
				return false
			end
		end
	end
end