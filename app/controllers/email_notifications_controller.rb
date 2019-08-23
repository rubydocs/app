class EmailNotificationsController < ApplicationController
  def create
    @email_notification = EmailNotification.new(email_notification_params)
    @email_notification.save
  end

  private

    def email_notification_params
      params.require(:email_notification).permit(:email, :doc_collection_id)
    end
end
