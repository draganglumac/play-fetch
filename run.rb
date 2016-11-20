require 'sinatra'

require_relative 'lib/helpers'

set :resources, File.dirname(__FILE__) + '/resources'

get '/*' do
  relative_path = params['splat'].first
  relative_path = 'index.html' if relative_path.empty?

  etag_for_file(relative_path)
  response_from_file(relative_path)
end

put '/*' do
  relative_path = params['splat'].first
  if relative_path.empty? or relative_path == 'index.html'
    relative_path = '/index.html'
  else
    save_request_to_file(request.body, relative_path)
  end

  etag_for_file(relative_path)
  201
end
