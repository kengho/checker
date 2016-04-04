class Api::V1::CheckerController < Api::V1::BaseController
  before_action :authenticate, only: [ :check ]

  def check
    require "net/ping"
    ip = params[:ip]
    if ip =~ /^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/
      check_request = Net::Ping::TCP.new(ip, 5100)
      availability = check_request.ping?
      render json: { "availability" => availability }
    else
      render nothing: true, status: 400, content_type: "text/html"
    end
  end

  private
    def authenticate
      token = ENV["CHECKER_TOKEN"]
      if !ActiveSupport::SecurityUtils.secure_compare(params[:token], token)
         render nothing: true, status: 401, content_type: "text/html"
      end
    end
end
