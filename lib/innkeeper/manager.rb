module Innkeeper
	class Manager
		attr_reader :app, :config
		attr_accessor :env

		def initialize(app)
			@app, @config = app, ::Innkeeper::Config.new
			yield @config if block_given?
			self
		end

		def call(_env)
			@env = _env
			env['innkeeper'] = ::Innkeeper::Proxy.new(self)

			if env['innkeeper'].present? && env['innkeeper'].halted? && env['innkeeper'].tenant.is_a?(Array)
				env['innkeeper'].tenant
			elsif env['innkeeper'].present? && env['innkeeper'].halted?
				env['innkeeper'].fail!
			else
				@app.call(env)
			end
		end

		def self.serialize_into_session(&block)
			::Innkeeper::SessionSerializer.send :define_method, :serialize, &block
		end

		def self.serialize_from_session(&block)
			::Innkeeper::SessionSerializer.send :define_method, :deserialize, &block
		end

		def self.check_in(&block)
			::Innkeeper::Proxy.send :define_method, :find_by_environment, &block
		end
	end
end
