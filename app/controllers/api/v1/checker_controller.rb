class Api::V1::CheckerController < Api::V1::BaseController
  before_action :authenticate, only: [ :check ]

  def check
    require "net/ping"
    ip = params[:ip]
    if ip =~ /^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/
      check_request = Net::Ping::TCP.new(ip, 5100)
      availability = check_request.ping?
      render json: { "data" => { "availability" => availability } }
    else
      render json: { "errors" => [{ title: "external", detail: "Expected ip like /^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/ as param" }] }
    end
  end

  private
    def authenticate
      token = ENV["CHECKER_TOKEN"]
      unless token
        render json: { "errors" => [{ title: "internal", detail: "Internal error 01" }] } and return
      end
      unless params[:token]
        render json: { "errors" => [{ title: "external", detail: "Expected token as param" }] } and return
      end
      if !ActiveSupport::SecurityUtils.secure_compare(params[:token], token)
         render nothing: true, status: 401, content_type: "text/html"
      end
    end
end
