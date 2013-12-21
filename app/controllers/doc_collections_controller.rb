class DocCollectionsController < ApplicationController
  def create
    # Extract project IDs and tags from parameters
    project_ids_and_tags = doc_collection_params[:docs_attributes].values.each_with_object({}) do |doc_hash, hash|
      hash[doc_hash[:project_id]] = doc_hash[:tag] #if doc_hash[:include] == '1'
    end

    # Find or create docs
    docs = project_ids_and_tags.map do |project_id, tag|
      Services::Docs::Find.call([], project_id: project_id, tag: tag).first ||
      Services::Docs::Create.call(project_id, tag)
    end

    # Find or create doc collection
    doc_collection = Services::DocCollections::Find.call([], docs: docs).first
    if doc_collection.nil?
      doc_collection = Services::DocCollections::Create.call(docs)
      Services::GenerateDocsAndDocCollection.perform_async :call, doc_collection.id unless Rails.env.development?
    end

    redirect_to doc_collection_path(doc_collection.slug)
  end

  def show
    @doc_collection = Services::DocCollections::Find.call([], slug: params[:doc_collection_slug]).first!
    render layout: @doc_collection.generating? ? 'doc_collections/generating' : 'doc_collections/displaying'
  end

  private

  def doc_collection_params
    params.require(:doc_collection).permit!
  end
end
