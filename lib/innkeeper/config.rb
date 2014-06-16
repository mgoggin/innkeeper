module Innkeeper
	class Config < Hash
		def self.hash_accessor(*names)
			names.each do |name|
				class_eval <<-METHOD, __FILE__, __LINE__ + 1
					def #{name}
						self[:#{name}]
					end

					def #{name}=(value)
						self[:#{name}] = value
					end
				METHOD
			end
		end

		hash_accessor :failure_app, :require_infer

		def initialize(other = {})
			merge!(other)
			self[:require_infer] ||= false
		end

		def infer_from_environment(*args, &block)
			::Innkeeper::Manager.infer_from_environment(*args, &block)
		end

		def serialize_into_session(*args, &block)
			::Innkeeper::Manager.serialize_into_session(*args, &block)
		end

		def serialize_from_session(*args, &block)
			::Innkeeper::Manager.serialize_from_session(*args, &block)
		end
	end
end