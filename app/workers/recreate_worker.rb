class RecreateWorker
  include Sidekiq::Worker

  def perform(id)
    dc=DocCollection.find(id)

    # Delete uploaded files
    s3 = AWS::S3.new
    bucket = s3.buckets[Settings.aws.bucket]
    bucket.objects.with_prefix("#{dc.slug}/").delete_all
    dc.uploaded_at=nil
    dc.save!

    # Delete local files
    Services::DocCollections::DeleteFiles.call dc
    dc.generated_at=nil
    dc.save!

    dc.docs.each do |d|
      FileUtils.rm_rf d.local_path if File.exists?(d.local_path)
    end

    Services::DocCollections::Process.perform_async id
  end
end
