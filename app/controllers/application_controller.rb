# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def home
    render "shared/home"
  end

  def cloudflare_verify
    render plain: ENV.fetch("CLOUDFLARE_2FA_VERIFY")
  end
end
