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

			if respond_to?(:deserialize)
				send(:deserialize, key)
			elsif key.split('--').size > 1
				klass, id = key.split('--')
				klass.constantize.where(:id => id).first
			else
				key
			end
		rescue
			key
		end

		def store(obj)
			session['innkeeper.key'] = if respond_to?(:serialize)
				send(:serialize, obj)
			elsif obj.respond_to?(:id)
				"#{obj.class.name}--#{obj.send(:id)}"
			else
				obj
			end

			obj
		end
	end
end