class Api::V1::CheckerController < Api::V1::BaseController
  before_action :authenticate, only: [:check]

  def check
    require "net/ping"
    ip = params[:ip]
    port = params[:port]

    ip_regexp = /^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/
    unless ip =~ ip_regexp
      render json: {
        "errors" => [{
          "title" => "external",
          "detail" => "Expected param 'ip' like /#{ip_regexp.source}/",
        }],
      }
      return
    end
    port_regexp = /^\d+$/
    unless port =~ port_regexp && port.to_i >= 1 && port.to_i <= 65535
      render json: {
        "errors" => [{
          "title" => "external",
          "detail" => "Expected param 'port' from 1 to 65535",
        }],
      }
      return
    end

    check_request = Net::Ping::TCP.new(ip, port)
    availability = check_request.ping?
    render json: { "data" => { "availability" => availability } } and return
  end

  private
    def authenticate
      local_token = ENV["CHECKER_TOKEN"]
      unless local_token
        render json: {
          "errors" => [{
            "title" => "internal",
            "detail" => "Internal error 01",
          }],
        }
        return
      end

      remote_token = params[:token]
      unless remote_token
        render json: {
          "errors" => [{
            "title" => "external",
            "detail" => "Expected param 'token'",
          }],
        }
        return
      end

      if !ActiveSupport::SecurityUtils.secure_compare(remote_token, local_token)
        render body: nil, status: :unauthorized, content_type: "text/html" and return
      end
    end
end
