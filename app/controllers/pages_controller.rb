class PagesController < ApplicationController
  include HighVoltage::StaticPage

  def show
    if params[:id] == 'home'
      @combined_doc_collection = DocCollection.new
      @single_doc_collections = []
      Projects::Find.call.find_each do |project|
        if project.name.in?(%w(Ruby Rails))
          @combined_doc_collection.docs.build(project: project)
        end
        single_doc_collection = DocCollection.new
        single_doc_collection.docs.build(project: project)
        @single_doc_collections << single_doc_collection
      end
    end

    super
  end
end
