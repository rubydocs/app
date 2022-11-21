# frozen_string_literal: true

module ApplicationHelper
  include Baseline::Helper

  def page_classes
    [
      controller.controller_name,
      { "create" => "new", "update" => "edit" }.fetch(controller.action_name, controller.action_name)
    ].join(" ")
  end

  def alert(level, text = nil, &block)
    tag.div class: "alert alert-#{level} alert-dismissible fade show" do
      concat tag.button(type: "button", class: "btn-close", data: { bs_dismiss: "alert" })
      concat text&.html_safe || capture_haml(&block)
    end
  end

  def flash_messages
    flash.map do |level, message|
      level = { notice: "success", alert: "danger" }[level.to_sym] || level
      alert level, message
    end.compact.join("\n").html_safe
  end

  def async_turbo_frame(name, **attributes, &block)
    # If a ActiveRecord record is passed to `turbo_frame_tag`,
    # `dom_id` is called to determine its DOM ID.
    # This exposes the record ID, which is not desirable if the record has a slug.
    if name.is_a?(ActiveRecord::Base) && name.respond_to?(:slug)
      name = [name.class.to_s.underscore, name.slug].join("_")
    end

    unless url = attributes[:src]
      raise "async_turbo_frame needs a `src` attribute."
    end

    uris = [
      url_for(url),
      request.fullpath
    ].map { Addressable::URI.parse _1 }
    uris_match = %i(path query_values).all? { uris.map(&_1).uniq.size == 1 }

    if uris_match
      turbo_frame_tag name, &block
    else
      turbo_frame_tag name, **attributes do
        render "shared/loading"
      end
    end
  end
end
