class DocCollectionsController < ApplicationController
  def create
    # Extract project IDs and tags from parameters
    project_ids_and_tags = doc_collection_params[:docs_attributes].values.each_with_object({}) do |doc_hash, hash|
      hash[doc_hash[:project_id]] = doc_hash[:tag]
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
      Services::DocCollections::Process.perform_async doc_collection.id unless Rails.env.development?
    end

    path = if params[:download_zip]
      doc_collection.zipfile
    else
      doc_collection.local_path
    end

    redirect_to doc_collection_path(File.basename(path))
  end

  def show
    @doc_collection = Services::DocCollections::Find.call([], slug: params[:slug]).first!

    case
    when @doc_collection.uploading?
      raise "Doc collection #{@doc_collection.name} is uploading, it shouldn't be possible to get here."
    when @doc_collection.generating?
      @email_notification = EmailNotification.new(doc_collection_id: @doc_collection.id)
    else
      redirect_to "http://docs.#{Settings.host}/#{File.basename(@doc_collection.local_path)}#{params[:path]}"
    end
  end

  private

  def doc_collection_params
    params.require(:doc_collection).permit!
  end
end
