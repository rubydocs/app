class PagesController < ApplicationController
  include HighVoltage::StaticPage

  def show
    if params[:id] == 'home'
      @single_doc_collections = []
      @combined_doc_collection = DocCollection.new
      Projects::Find.call([], order: 'name').each do |project|
        single_doc_collection = DocCollection.new
        single_doc_collection.docs.build(project: project)
        @single_doc_collections << single_doc_collection
        if project.name.in?(%w(Ruby Rails))
          @combined_doc_collection.docs.build(project: project)
        end
      end
    end

    super
  end
end
