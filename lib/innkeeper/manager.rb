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
			env['multidomain'] = ::Innkeeper::Proxy.new(self)
			if env['multidomain'].halted?
				env['multidomain'].fail!
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

		def self.infer_from_environment(&block)
			::Innkeeper::Proxy.send :define_method, :find_by_environment, &block
		end
	end
end