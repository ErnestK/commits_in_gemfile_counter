require 'sinatra'
require_relative 'service/build_chart_for_repo.rb'

set :views, 'views'

class App < Sinatra::Base
  get '/' do
    erb :input_form
  end

  post '/' do
    erb :index, :locals => {'chart' => BuildChartForRepo.new().call(params[:repo_url])}
  end
end
  