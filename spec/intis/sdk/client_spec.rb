require 'spec_helper'
require 'intis/sdk'
require 'net/http'
require 'logger'
require 'date'

describe Intis::Sdk::Client do
	let(:log) {
	  Logger.new(STDOUT).tap { |l| l.level = Logger::DEBUG }
	}

	before(:context) do
    @client = Intis::Sdk::Client.new({
			login: 'your api login', 
			api_key: 'your api key', 
			api_host: 'go.intistele.com'
		})
  end

	it 'should return balance' do
		response = @client.get_balance
		expect(response[:money]).to be
		expect(response[:bonusAmount]).to be
		expect(response[:currency]).to be
	end

	it 'should return phone bases' do
		response = @client.get_base
		expect(response).to be
	end

	it 'should return phones' do
		response = @client.get_phone(247)
		expect(response).to be
	end

	it 'should return senders' do
		response = @client.get_senders
		expect(response).to be
	end

	it 'should return templates' do
		response = @client.get_template
		expect(response).to be
	end

	it 'should return stat for current month' do
		response = @client.get_stat_by_month(Date.today.strftime("%Y-%m"))
		expect(response).to be
	end

	it 'should make hlr request' do
		response = @client.hlr('79051111111')
		expect(response).to be
	end	

	it 'should return hlr stat for current month' do
		response = @client.get_hlr_stat(Date.today.strftime("%Y-%m-%d"), Date.today.strftime("%Y-%m-%d"))
		expect(response).to be
	end

	it 'should return operator by phone' do
		response = @client.get_operator("79051111111")
		expect(response[:price]).to be
		expect(response[:country]).to be
		expect(response[:operator]).to be
		expect(response[:currency]).to be
		expect(response[:phone]).to be
		expect(response[:regionCode]).to be
	end	

	it 'should return prices' do
		response = @client.get_prices
		expect(response).to be
	end	

	it 'should return incoming' do
		response = @client.get_incoming_by_date(Date.today.strftime("%Y-%m-%d"))
		expect(response).to be
	end	
end