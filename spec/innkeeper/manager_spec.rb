require 'spec_helper'

describe Innkeeper::Manager do
	let(:app) { success_app }

	it 'should insert a Proxy object in to the Rack environment when a subdomain is present' do
		middleware = setup_with_failure_app
		env = env_for('http://test.example.com')
		middleware.call(env)
		expect(env['innkeeper']).to be_an_instance_of(Innkeeper::Proxy)
		expect(env['innkeeper'].tenant).to eq('test')
	end

	it 'should insert a Proxy object in to the Rack environment when subdomain is "www"' do
		middleware = setup_with_failure_app
		env = env_for('http://www.example.com')
		middleware.call(env)
		expect(env['innkeeper']).to be_an_instance_of(Innkeeper::Proxy)
		expect(env['innkeeper'].tenant).to be_nil
	end

	it 'should insert a Proxy object in to the Rack environment when subdomain is blank' do
		middleware = setup_with_failure_app
		env = env_for('http://example.com')
		middleware.call(env)
		expect(env['innkeeper']).to be_an_instance_of(Innkeeper::Proxy)
		expect(env['innkeeper'].tenant).to be_nil
	end

	it 'should return a 200 status with body of "OK!" with a valid subdomain' do
		middleware = setup_with_failure_app
		env = env_for('http://test.example.com')
		code, headers, body = middleware.call(env)
		expect(code).to eq(200)
		expect(body.first).to eq('OK!')
	end

	it 'should return a 412 status with body of "Fail!" with a bad subdomain' do
		middleware = setup_with_failure_app
		env = env_for('http://die.example.com')
		code, headers, body = middleware.call(env)
		expect(code).to eq(412)
		expect(body.first).to eq('Fail!')
	end

	it 'should return a 401 status with a body of "Fail!" when explicitly calling fail!' do
		middleware = setup_with_explicit_fail
		env = env_for('http://www.example.com')
		code, headers, body = middleware.call(env)
		expect(code).to eq(401)
		expect(body.first).to eq('Fail!')
	end
end