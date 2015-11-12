require 'fog'
require 'digest/md5'

# AWS S3 - Fog Stream Download and Upload


def stream_download( bucket, upload )

   connection = Fog::Storage.new
	({ 
	:provider => "AWS", 
	:aws_access_key_id => access_key, 
	:aws_secret_access_key => secret_key 
	})

   bucket = connection.directories.new(:key => "myS3bucket")

   open("mydownloadedfile.txt", 'w') do |f|
      bucket.files.get("mydownloadedfile.txt") do |chunk,remaining_bytes,total_bytes|
         f.write chunk
      end
   end

   downloaded_file_md5 = Digest::MD5.file(mydownloadedfile.txt).to_s #This method won't take up much memory
   remote_file_md5 = connection.head_object("myS3bucket", "mydownloadedfile.txt")).data[:headers]["ETag"].gsub('"','')

   if remote_md5 == local_md5
     puts "MD5 matched!"
   else
     puts "MD5 match failed!"
   end
end 

# See the Amazon docs for more information. 
# And any files uploaded larger than 5GBs from the console, 
# fog, etc.. will not have a simple MD5 either.

# This is how you stream an upload to S3 using fog:

def stream_upload( bucket, upload )

   connection = Fog::Storage.new
   	({ 
	:provider => "AWS", 
	:aws_access_key_id => access_key, 
	:aws_secret_access_key => secret_key 
	})

   bucket = connection.directories.new(:key => "myS3bucket")

   local_file_md5 = Digest::MD5.file("myfiletoupload.txt")
   s3_file_object = bucket.files.create
	(
	:key => "myfiletoupload.txt", 
	:body => File.open("myfiletoupload.txt"), 
	:content_type => "text/plain", 
	:acl => "private"
	)

   if s3_file_object.etag != local_file_md5
     puts "MD5 match failed!"
   else
     puts "MD5 matched!"
   end
end

config = YAML::load(File.open(ENV['HOME']+'/.fog'))[:default]

stream_upload( bucket, file )
stream_download( bucket, file )
