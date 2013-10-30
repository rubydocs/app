class DocCollectionsController < ApplicationController
  def create
    projects_and_tags = doc_collection_params[:docs_attributes].values.each_with_object({}) do |doc_hash, hash|
      hash[doc_hash[:project_id]] = doc_hash[:tag] if doc_hash[:include] == '1'
    end
    doc_collection = Services::DocCollections::Find.call(projects_and_tags: projects_and_tags)
    redirect_to doc_colelction.url if doc_collection.present?
    Services::DocCollections::Create.call projects_and_tags
  end

  private

  def doc_collection_params
    params.require(:doc_collection).permit!
  end
end
