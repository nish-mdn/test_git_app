require 'aws-sdk-s3'  # v2: require 'aws-sdk'
require 'base64'
require 'rubygems'
require 'zip'
class UploadArtifactAsZip
  def initialize
    Aws.config.update({region: 'us-east-1',credentials: Aws::Credentials.new("#{ENV['AWS_ACCESS_KEY']}", "#{ENV['AWS_SECRET_ACCESS_KEY']}")})
    @s3 = Aws::S3::Resource.new
    @bucket = @s3.bucket("mdn-codedeploy-artifact")
  end

  # def initialize
  #   Aws.config.update({region: 'us-east-1',credentials: Aws::Credentials.new("AKIAIILF5TYQXCIEFS7A", "MgpflHArun0amHj8B1w8cFxYxIvYQun5SW0Em0mh")})
  #   @s3 = Aws::S3::Resource.new
  #   @bucket = @s3.bucket("mdn-codedeploy-artifact")
  # end

  def create_zip_and_upload
    create_zip
    upload_artifact
  end

  def create_zip
    directory_to_zip = "#{ENV['TRAVIS_BUILD_DIR']}/blog"
    output_file = "#{ENV['TRAVIS_BUILD_DIR']}/blog/artifact.zip"
    zf = ZipFileGenerator.new(directory_to_zip, output_file)
    zf.write()  	
  end 	

  def upload_artifact
    # Create the object to upload
    zip_obj = @bucket.object("my-test-build/latest/artifact.zip")
    # Upload it
    zip_obj.upload_file("#{ENV['TRAVIS_BUILD_DIR']}/blog/artifact.zip")    	
  end 	

end


class ZipFileGenerator
  # Initialize with the directory to zip and the location of the output archive.
  def initialize(input_dir, output_file)
    @input_dir = input_dir
    @output_file = output_file
  end

  # Zip the input directory.
  def write
    entries = Dir.entries(@input_dir) - %w(. ..)

    ::Zip::File.open(@output_file, ::Zip::File::CREATE) do |zipfile|
      write_entries entries, '', zipfile
    end
  end

  private

  # A helper method to make the recursion work.
  def write_entries(entries, path, zipfile)
    entries.each do |e|
      zipfile_path = path == '' ? e : File.join(path, e)
      disk_file_path = File.join(@input_dir, zipfile_path)
      puts "Deflating #{disk_file_path}"

      if File.directory? disk_file_path
        recursively_deflate_directory(disk_file_path, zipfile, zipfile_path)
      else
        put_into_archive(disk_file_path, zipfile, zipfile_path)
      end
    end
  end

  def recursively_deflate_directory(disk_file_path, zipfile, zipfile_path)
    zipfile.mkdir zipfile_path
    subdir = Dir.entries(disk_file_path) - %w(. ..)
    write_entries subdir, zipfile_path, zipfile
  end

  def put_into_archive(disk_file_path, zipfile, zipfile_path)
    zipfile.get_output_stream(zipfile_path) do |f|
      f.write(File.open(disk_file_path, 'rb').read)
    end
  end
end

art  = UploadArtifactAsZip.new
art.create_zip_and_upload