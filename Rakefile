require './routster'
require 'rspec'

namespace :routster do

	desc "Pass routes in format: AB5 DC3 BE1 to get necessary information"
	task :digest do
		ARGV.shift
		routster = Routster.new(ARGV.map{|a| a.sub(',','') })
		puts ""
		puts "Now Routster has #{routster.routes} routes"
		puts "Try to find answers:"
		# 1
		['A-B-C', 'A-D', 'A-D-C', 'A-E-B-C-D', 'A-E-D'].each do |route|
			routster.distance_for(route, true)
		end
		# 2
		puts "The number of trips starting at C and ending at C with a maximum of 3 stops:"
		puts routster.trips(starts: 'C', ends: 'C', count: 3, precise: :maximum, kind: :stops).size
		puts "The number of trips starting at A and ending at C with exactly 4 stops:"
		puts routster.trips(starts: 'A', ends: 'C', count: 4, precise: :exactly, kind: :stops).size
		# 3
		['A-C', 'B-B'].each do |route|
			routster.shortest_route(route, true)
		end
		# 4
		puts "The number of different routes from C to C with a distance of less than 30:"
		puts routster.trips(starts: 'C', ends: 'C', count: 30, precise: :less_than, kind: :distance).size
		puts ""
		puts ""
	end

end

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end
