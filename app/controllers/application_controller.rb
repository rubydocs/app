# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def home
    render "/home"
  end
end
