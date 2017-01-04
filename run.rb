require 'sinatra'
require 'erb'

require_relative 'lib/helpers'

set :resources, File.dirname(__FILE__) + '/resources'
set :views, settings.resources

get '/*' do
  relative_path = params['splat'].first
  puts relative_path
  relative_path = 'index.erb' if relative_path.empty? or relative_path == 'index.html'

  begin
    etag_for_file(relative_path)
    if relative_path == 'index.erb'
      erb :index
    else
      response_from_file(relative_path)
    end
  rescue
    404
  end
end

put '/*' do
  relative_path = params['splat'].first
  if relative_path.empty? or relative_path == 'index.html'
    relative_path = '/index.erb'
  else
    save_request_to_file(request.body, relative_path)
  end

  etag_for_file(relative_path)
  201
end

delete '/*' do
  relative_path = params['splat'].first
  if relative_path.empty? or relative_path == 'index.html'
    403
  else
    if delete_file(relative_path)
      204
    else
      403
    end
  end
end
