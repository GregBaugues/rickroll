require 'sinatra'
require 'twilio-ruby'

def twilio_client
  Twilio::REST::Client.new ENV['ACCOUNT_SID'], ENV['AUTH_TOKEN']
end

def rickroll(phone)
  twilio_client.account.calls.create(
    to: phone,
    from: "+18006582343",
    url: "http://example.ngrok.com/voice"
  )
end

post '/voice' do
  content_type 'text/xml'
  "<Response>
    <Play>http://demo.twilio.com/docs/classic.mp3</Play>
  </Response>"
end

post '/sms' do
  rickroll(params[:Body])
  content_type 'text/xml'
  "<Response>
    <Message>Attempting to rickroll` #{params[:Body]}</Message>
  </Response>"
end

