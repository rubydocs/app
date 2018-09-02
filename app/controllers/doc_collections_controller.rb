class DocCollectionsController < ApplicationController
  def create
    # Extract project IDs and tags from parameters
    project_ids_and_tags = doc_collection_params[:docs_attributes].values.each_with_object({}) do |doc_hash, hash|
      hash[doc_hash[:project_id]] = doc_hash[:tag]
    end

    # Find or create docs
    docs = project_ids_and_tags.map do |project_id, tag|
      Docs::Find.call([], project_id: project_id, tag: tag).first ||
      Docs::Create.call(project_id, tag)
    end

    # Find or create doc collection
    doc_collection =
      DocCollections::Find.call([], docs: docs).first ||
      DocCollections::Create.call(docs)

    if params[:download_zip]
      redirect_to doc_collection_path(File.basename(doc_collection.zipfile))
    else
      redirect_to doc_collection_path(File.basename(doc_collection.local_path), trailing_slash: true)
    end
  end

  def show
    @doc_collection = DocCollections::Find.call([], slug: params[:slug]).first!

    case
    when @doc_collection.uploading? || @doc_collection.generating?
      @email_notification = EmailNotification.new(doc_collection_id: @doc_collection.id)
      render formats: :html
      # unless request.format.zip? || request.fullpath =~ %r(/\z)
      #   redirect_to url_for(params.merge(trailing_slash: true))
      # end
    when request.format.zip?
      path = File.basename(@doc_collection.zipfile)
      redirect_to "http://zip.#{Settings.host}/#{path}"
    else
      path = [File.basename(@doc_collection.local_path), params[:path]].join
      redirect_to "https://#{Settings.host}/d/#{path}"
    end
  end

  private

  def doc_collection_params
    params.require(:doc_collection).permit!
  end
end
