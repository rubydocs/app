class AirbrakeDeliveryWorker
  include Sidekiq::Worker

  def perform(notice_xml)
    Airbrake.sender.send_to_airbrake notice_xml
  end
end
