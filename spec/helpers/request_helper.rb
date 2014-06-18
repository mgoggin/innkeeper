module Innkeeper
	module Spec
		module Helpers
			def setup_with_failure_app
				Innkeeper::Manager.new(app) do |config|
					config.require_infer = true
					config.redirect_on_failure = :failure_app

					config.failure_app = ->(request) { [412, {}, ['Fail!']] }

					config.check_in do |subdomain, host_domain, request|
						if subdomain == 'www' || subdomain.nil?
							skip!
						elsif subdomain != 'die'
							subdomain
						else
							nil
						end
					end
				end
			end

			def setup_with_redirect(redirect_type)
				Innkeeper::Manager.new(app) do |config|
					config.require_infer = true
					config.redirect_on_failure = redirect_type

					config.check_in do |subdomain, host_domain, request|
						if subdomain == 'www' || subdomain.nil?
							skip!
						elsif subdomain != 'die'
							subdomain
						else
							nil
						end
					end
				end
			end

			def setup_with_explicit_fail
				Innkeeper::Manager.new(app) do |config|
					config.require_infer = true
					config.redirect_on_failure = :failure_app

					config.failure_app = ->(request) { [401, {}, ['Fail!']] }

					config.check_in do |subdomain, host_domain, request|
						fail!
					end
				end
			end

			def success_app
				->(request) { [200, { 'Content-Type' => 'text/plain' }, ['OK!']] }
			end

			def env_for(url, options = {})
				::Rack::MockRequest.env_for(url, options.merge('rack.session' => {}))
			end
		end
	end
end