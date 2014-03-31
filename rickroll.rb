require './settings.rb'
require 'sinatra'
require 'twilio-ruby'

include Settings

post '/sms' do
  phone = clean_phone_number(params[:Body])
  rickroll(phone)

  content_type 'text/xml'
  "<Response><Message>Attempting to RickRoll #{phone}</Message></Response>"
end

post '/call' do
  content_type 'text/xml'
  "<Response><Play>http://demo.twilio.com/docs/classic.mp3</Play></Response>"
end

def client
  Twilio::REST::Client.new Settings.ACCOUNT_SID, Settings.AUTH_TOKEN
end

def rickroll(phone)
  client.account.calls.create(
    to: phone,
    from: Settings.TWILIO_PHONE,
    url: Settings.BASE_URL + "/call"
  )
end

def clean_phone_number(string)
  string.gsub!(/[\(\)\-\.\s]/, '')
  unless string[0..1] == "+1"
    string.prepend("1") unless string[0].eql? "1"
    string.prepend("+") unless string[0].eql? "+"
  end
  string
end