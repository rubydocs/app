class PagesController < ApplicationController
  include HighVoltage::StaticPage

  def show
    if params[:id] == 'home'
      @combined_doc_collection = DocCollection.new
      @single_doc_collections = []
      Project.find_each do |project|
        single_doc_collection = DocCollection.new
        [@combined_doc_collection, single_doc_collection].each do |doc_collection|
          doc_collection.docs.build(project: project)
        end
        @single_doc_collections << single_doc_collection
      end
    end

    super
  end
end
