require 'sinatra'
require 'digest/sha1'
require 'fileutils'

def etag_for_file(relative_path)
  full_path = "#{settings.resources}/#{relative_path}"
  contents = File.open(full_path, 'r') { |f| f.read }
  etag(Digest::SHA1.hexdigest contents) unless contents.nil? or contents.empty?
end

def response_from_file(relative_path)
  full_path = "#{settings.resources}/#{relative_path}"
  send_file(full_path)
end

def save_request_to_file(request_body, relative_path)
  parts = relative_path.split('/')
  if parts.size > 1
    dir_path = "#{settings.resources}/#{parts[0...-1].join('/')}"
    FileUtils::mkdir_p(dir_path) # create directories recursively - like mkdir -p
  end

  full_path = "#{settings.resources}/#{relative_path}"
  request_body.rewind
  File.open(full_path, 'wb') { |f| f.write(request_body.read) }
end

def delete_file(relative_path)
  path = "#{settings.resources}/#{relative_path}"
  if File::file?(path)
    FileUtils::remove_file(path)
    true
  else
    false
  end  
end
