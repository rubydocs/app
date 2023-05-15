# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def home
    render "/home"
  end

  def health
    Doc.count
    expires_now
    head :ok
  end
end
