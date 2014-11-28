require './routster'
require 'rspec'

namespace :routster do

	desc "Pass routes in format: ROUTES=AB5,DC3,BE1 and ROUTE=A-C to get distance"
	task :distance do
		routster = call_routster(Routster.new(ENV['ROUTES'].split(",")))		
		routster.distance_for(ENV['ROUTE'], true)
		puts ""
	end

	desc "Pass routes in format: ROUTES=AB5,DC3,BE1 and START=A and STOP=C to get all different trips"
	task :trips do
		routster = call_routster(Routster.new(ENV['ROUTES'].split(",")))		
		stops = routster.trips(starts: ENV['START'], ends: ENV['STOP'], count: ENV['COUNT'], precise: ENV['PRECISE'].to_sym, kind: ENV['KIND'])
		puts "The number of trips starting at #{ENV['START']} and ending at #{ENV['STOP']} with #{ENV['PRECISE']} #{ENV['COUNT']} stops"
		puts ""
	end

	desc "Pass routes in format: ROUTES=AB5,DC3,BE1 and START=A and STOP=C to get the shortest route"
	task :shortcut do
		routster = call_routster(Routster.new(ENV['ROUTES'].split(",")))		
		stops = routster.shortest_route(ENV['START'], ENV['STOP'], true)
		puts ""
	end

	def call_routster	
		routster = Routster.new(ENV['ROUTE'].split(","))
		puts ""
		puts "Now Routster has #{routster.routes.size} routes"
		puts ""
	end

end

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end
