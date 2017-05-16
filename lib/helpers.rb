require 'sinatra'
require 'digest/sha1'
require 'fileutils'
require 'date'

def etag_for_file(relative_path)
  dir_path, file = dir_path_and_file(relative_path)
  full_path = "#{dir_path}/#{file}"
  contents = File.open(full_path, 'r') { |f| f.read }
  etag(Digest::SHA1.hexdigest contents) unless contents.nil? or contents.empty?
end

def response_from_file(relative_path, response)
  dir_path, file = dir_path_and_file(relative_path)
  full_path = "#{dir_path}/#{file}"
  if file =~ /.*\.tar\.gz/
    response.headers['Content-Disposition'] = "attachment; filename=\"#{file}\""
  end
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

def configured_paths(relative_path, index_path=nil)
  paths = Dir.glob("#{relative_path}/**/*").inject([]) do |acc, path|
    if File.file?(path)
      acc << path
    else
      acc
    end
  end

  paths.map do |path|
    if index_path and path == index_path
      '/index.html'
    else
      path.gsub(/#{relative_path}/, '').gsub('_', '')
    end
  end
end

def backup
  today = Date.today.strftime('%Y%m%d')
  `rm resources/*.tar.gz`
  `tar cvf "resources/#{today}.tar" resources`
  `gzip "resources/#{today}.tar"`
  "#{today}.tar.gz"
end
