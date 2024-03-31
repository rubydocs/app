class ApplicationController < ActionController::Base
  include Baseline::ControllerExtensions

  def home
    render "/home"
  end
end
