module ApplicationHelper
  def site_id
    [].tap do |parts|
      case
      when controller.status != 200
        parts << 'error' << controller.status
      when controller.controller_name == 'pages'
        parts << params[:id]
      else
        parts << controller.action_name

        if %w(index).any? { |prefix| controller.action_name =~ /\A#{prefix}/ }
          parts << controller.controller_name
        elsif %w(show edit update new create).any? { |prefix| controller.action_name =~ /\A#{prefix}/ }
          parts << controller.controller_name.singularize
        end
      end
    end.join('-').dasherize
  end
end
