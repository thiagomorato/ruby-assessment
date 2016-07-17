require 'rest-client'

module Mailgun

  def self.send email, subject, text, campaign_id
    begin
      endpoint = api_url + '/messages'

      data = {
        :from => ENV['MAILGUN_DEFAULT_SENDER'],
        :to => email,
        :subject => subject,
        :text => text,
        "o:campaign" => campaign_id
      };

      response = RestClient.post endpoint, data
      JSON.parse response
    rescue => e
      handle_errors e

      false
    end
  end

  def self.is_suppressed? email
    is_bounced? email or is_unsubscribed? email or is_complained? email
  end

  def self.is_bounced? email
    resourse_exists? '/bounces/' + email
  end

  def self.is_unsubscribed? email
    resourse_exists? '/unsubscribes/' + email
  end

  def self.is_complained? email
    resourse_exists? '/complaints/' + email
  end

  def self.resourse_exists? endpoint
    begin
      RestClient.get api_url + endpoint
      true
    rescue RestClient::ResourceNotFound => e
      return false if e.response.code == 404
    rescue => e
      handle_errors e
    end
  end

  def self.sent_to email
    begin
      endpoint = api_url + '/events'

      data = {
        :recipient => email,
        :event => 'delivered'
      };

      response = RestClient.get endpoint, :params => data
      JSON.parse response
    rescue => e
      handle_errors e

      false
    end
  end

  def self.handle_errors exception
    #TODO do some login, maybe throw its own exception

    nil
  end

  def self.api_url
    "https://api:#{ENV['MAILGUN_KEY']}"\
    "@api.mailgun.net/v3/#{ENV['MAILGUN_DOMAIN']}"
  end
end
