class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Add info to lograge payload
  def append_info_to_payload(payload)
    super
    payload[:request_id] = request.uuid
    payload[:remote_ip]  = request.remote_ip
  end
end
