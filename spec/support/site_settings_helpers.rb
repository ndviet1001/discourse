# frozen_string_literal: true

module SiteSettingsHelpers
  def new_settings(provider)
    Class.new do
      extend SiteSettingExtension
      # we want to avoid leaking a big pile of MessageBus subscriptions here (1 per class)
      # so we set listen_for_changes to false
      self.listen_for_changes = false
      self.provider = provider
    end
  end

  def setup_s3
    SiteSetting.enable_s3_uploads = true

    SiteSetting.s3_region = 'us-west-1'
    SiteSetting.s3_upload_bucket = "s3-upload-bucket"

    SiteSetting.s3_access_key_id = "some key"
    SiteSetting.s3_secret_access_key = "some secrets3_region key"

    stub_request(:head, "https://#{SiteSetting.s3_upload_bucket}.s3.#{SiteSetting.s3_region}.amazonaws.com/")
  end

  def stub_upload(upload)
    url = "https://#{SiteSetting.s3_upload_bucket}.s3.#{SiteSetting.s3_region}.amazonaws.com/original/1X/#{upload.sha1}.#{upload.extension}?acl"
    stub_request(:put, url)
  end
end
