module Innkeeper
	class Proxy
		include ::Innkeeper::Rack::Mixin
		extend ::Forwardable

		attr_accessor :manager

		def_delegators :manager, :env, :config

		def initialize(manager)
			@manager = manager
			@halted = false

			if respond_to?(:find_by_environment)
				_domain = send(:find_by_environment, request)
				halt! unless _domain
				send("domain=".to_sym, _domain)
			end
		end

		def domain
			@_domain ||= session_serializer.fetch
		end

		def domain=(obj)
			return unless obj
			@_domain = session_serializer.store(obj)
		end

		def session_serializer
			@_session_serializer ||= ::Innkeeper::SessionSerializer.new(self)
		end

		def halted?
			@halted
		end

		def fail!
			halt!
			if config.require_infer && config.failure_app.respond_to?(:call)
				config.failure_app.call(request)
			end
		end

		def halt!
			@halted = true
		end
	end
end