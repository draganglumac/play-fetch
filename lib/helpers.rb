require 'sinatra'
require 'digest/sha1'
require 'fileutils'

def etag_for_file(relative_path)
  dir_path = construct_folder_path(relative_path)
  parts = relative_path.split('/')
  full_path = "#{dir_path}/#{parts[-1]}"
  contents = File.open(full_path, 'r') { |f| f.read }
  etag(Digest::SHA1.hexdigest contents) unless contents.nil? or contents.empty?
end

def response_from_file(relative_path)
  dir_path = construct_folder_path(relative_path)
  parts = relative_path.split('/')
  full_path = "#{dir_path}/#{parts[-1]}"
  send_file(full_path)
end

def save_request_to_file(request_body, relative_path)
  dir_path = construct_folder_path(relative_path)
  FileUtils::mkdir_p(dir_path) # create directories recursively - like mkdir -p

  parts = relative_path.split('/')
  full_path = "#{dir_path}/#{parts[-1]}"
  
  request_body.rewind
  File.open(full_path, 'wb') { |f| f.write(request_body.read) }
end

def delete_file(relative_path)
  dir_path = construct_folder_path(relative_path)
  parts = relative_path.split('/')
  path = "#{dir_path}/#{parts[-1]}"
  if File::file?(path)
    FileUtils::remove_file(path)
    true
  else
    false
  end  
end

def construct_folder_path(relative_path)
  parts = relative_path.split('/')
  dir_path = settings.resources
  parts[0..-2].each do |d|
    dir_path = "#{dir_path}/_#{d}"
  end
  dir_path
end
