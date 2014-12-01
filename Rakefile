require './routster'
require 'rspec'

namespace :routster do

  desc "Pass routes in format: ROUTES=AB5,DC3,BE1 and ROUTE=A-C to get distance"
  task :distance do	
    route = call_routster.distance_for(ENV['ROUTE'])
    p "The distance of the route #{ENV['ROUTE']} is #{route[:length]}"
    p " because #{status}" if route[:status].nil?
    puts ""
  end

  desc "Pass routes in format: ROUTES=AB5,DC3,BE1 and START=A and STOP=C to get all different trips"
  task :trips do
    stops = call_routster.trips(ENV['START'], ENV['STOP'], {count: ENV['COUNT'], precise: ENV['PRECISE'].to_sym, kind: ENV['KIND']})
    puts "The number of trips starting at #{ENV['START']} and ending at #{ENV['STOP']} with #{ENV['PRECISE']} #{ENV['COUNT']} stops"
    puts ""
  end

  desc "Pass routes in format: ROUTES=AB5,DC3,BE1 and START=A and STOP=C to get the shortest route"
  task :shortcut do	
    route = call_routster.shortest_route(ENV['START'], ENV['STOP'], true)
    puts "The length of the shortest route from #{ENV['START']} to #{ENV['STOP']} is #{route[:length]}"
    puts ""
  end

  def call_routster	
    routster = Routster.new(ENV['ROUTES'].split(","))
    puts ""
    puts "Now Routster has #{routster.routes.size} routes"
    puts ""
    routster
  end

end

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end
