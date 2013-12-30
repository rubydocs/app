class PagesController < ApplicationController
  include HighVoltage::StaticPage

  def show
    if params[:id] == 'home'
      @doc_collection = DocCollection.new
      Project.find_each do |project|
        @doc_collection.docs.build(project: project)
      end
    end

    super
  end
end
