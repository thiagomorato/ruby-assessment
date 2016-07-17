module Api
  class MailgunEventsController < ApplicationController

    skip_before_filter :verify_authenticity_token

    def handle_event
      begin
        if verify params[:token], params[:timestamp], params[:signature]

          case params[:event]
          when 'opened'
            logEvent(
              params[:event],
              params[:recipient],
              params[:city],
              params[:region],
              params[:country]
            )
          when 'clicked'
            logEvent(
              params[:event],
              params[:recipient],
              params[:city],
              params[:region],
              params[:country]
            )
          end
          render :nothing => true, :status => 200
        else
          render :nothing => true, :status => 400
        end
      rescue
        render :nothing => true, :status => 406
      end
    end

    protected

    def logEvent (type, recipient, city, region, country)
      message = "Email from #{recipient} #{type} on #{city}, #{region}, #{country}"
      logger.debug "\033[32m"+message+"\033[0m"
    end

    def verify(token, timestamp, signature)
      digest = OpenSSL::Digest::SHA256.new
      data = [timestamp, token].join
      signature == OpenSSL::HMAC.hexdigest(digest, ENV['MAILGUN_KEY'], data)
    end
  end
end
