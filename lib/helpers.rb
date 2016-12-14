require 'sinatra'
require 'digest/sha1'
require 'fileutils'

def etag_for_file(relative_path)
  dir_path, file = dir_path_and_file(relative_path)
  full_path = "#{dir_path}/#{file}"
  contents = File.open(full_path, 'r') { |f| f.read }
  etag(Digest::SHA1.hexdigest contents) unless contents.nil? or contents.empty?
end

def response_from_file(relative_path)
  dir_path, file = dir_path_and_file(relative_path)
  full_path = "#{dir_path}/#{file}"
  send_file(full_path)
end

def save_request_to_file(request_body, relative_path)
  dir_path, file = dir_path_and_file(relative_path)
  FileUtils::mkdir_p(dir_path) # create directories recursively - like mkdir -p
  full_path = "#{dir_path}/#{file}"

  request_body.rewind
  File.open(full_path, 'wb') { |f| f.write(request_body.read) }
end

def delete_file(relative_path)
  dir_path, file = dir_path_and_file(relative_path)
  path = "#{dir_path}/#{file}"
  if File::file?(path)
    FileUtils::remove_file(path)
    true
  else
    false
  end  
end

def dir_path_and_file(relative_path)
  parts = relative_path.split('/')
  dir_path = parts[0..-2].inject(settings.resources) { |path, d| "#{path}/_#{d}" }
  [dir_path, parts[-1]]
end
