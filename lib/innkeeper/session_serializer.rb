module Innkeeper
	class SessionSerializer
		include ::Innkeeper::Rack::Mixin
		extend ::Forwardable

		attr_accessor :proxy

		def_delegator :proxy, :env

		def initialize(proxy)
			@proxy = proxy
		end

		def fetch
			key = session['innkeeper.key']
			return nil unless key

			respond_to?(:deserialize) ? send(:deserialize, key) : key
		end

		def store(obj)
			session['innkeeper.key'] = respond_to?(:serialize) ? send(:serialize, obj) : obj
			obj
		end
	end
end