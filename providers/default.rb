use_inline_resources

def whyrun_supported?
  true
end

action :create do
  do_s3_file(:create)
end

action :create_if_missing do
  do_s3_file(:create_if_missing)
end

action :delete do
  do_s3_file(:delete)
end

action :touch do
  do_s3_file(:touch)
end

def do_s3_file(resource_action)
  remote_path = new_resource.remote_path
  remote_path = "/#{remote_path}" unless remote_path.chars.first == '/'
  s3file = S3UrlGenerator.new(new_resource.bucket, remote_path, new_resource.aws_access_key_id, new_resource.aws_secret_access_key)

  remote_file new_resource.name do
     path                  new_resource.path
     source                s3file.url
     headers               s3file.headers
     owner                 new_resource.owner
     group                 new_resource.group
     mode                  new_resource.mode
     checksum              new_resource.checksum
     use_etag              new_resource.use_etag
     use_last_modified     new_resource.use_last_modified
     backup                new_resource.backup
     inherits              new_resource.inherits if Platform.windows?
     atomic_update         new_resource.atomic_update
     force_unlink          new_resource.force_unlink
     manage_symlink_source new_resource.manage_symlink_source
     sensitive             new_resource.sensitive unless new.resource_sensitive.nil?
     action                resource_action
  end
end
