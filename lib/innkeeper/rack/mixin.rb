module Innkeeper
	module Rack
		module Mixin
			def session
				env['rack.session']
			end
			alias :raw_session :session

			def request
				@request ||= ::Rack::Request.new(env)
			end

			def params
				request.params
			end

			def reset_session!
				raw_session.clear
			end
		end
	end
end