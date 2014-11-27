require 'time'
require 'json'
require 'active_model'

class Routster

	include ActiveModel::Validations

	attr_reader :routes

	def initialize(routes = [])
		@routes = []
		parse_routes(routes)
	end

	def distance_for(route, print = false)
		stops = parse_stops(route)
		routes = find_direct_routes(stops)
		length = routes.length == (stops.size - 1) ? routes.map{|r| r[:length]}.inject{|sum,x| sum + x } : nil
		status = length == nil ? 'NO SUCH ROUTE' : nil
		puts "The distance of the route #{route} is #{length} #{status != nil ? "because #{status}" : ""}" if print
		{status: status, length: length}
	end

	def trips(*args)
		#puts args.inspect
		puts find_possible_routes(args[0][:starts], args[0][:ends]).inspect
	end

	def shortest_route(route, print = false)

		puts "The length of the shortest route from to is " if print
	end

	private 

		def parse_routes(routes)
			routes.each do |route|
				@routes << {starts: route[0], ends: route[1], length: route[2..route.size].to_i}
			end
		end

		def parse_stops(route)
			route.split('-')
		end

		def find_direct_routes(stops)
			result = []
			stops.each_with_index do |stop, index|
				next if index + 1 == stops.size
				result << @routes.find {|r| r[:starts] == stop && r[:ends] == stops[index + 1] }
			end
			result.flatten.compact
		end

		def find_possible_routes(start, stop)
			step1 = @routes.select {|r| r[:starts] == start }
			step2 = step1.select {|r| r[:ends] == stop}
			if step2.size == 0
				#puts "!!!!!"
				#puts "#{start} - #{stop}"
				#puts step1.inspect
				#puts "===="
				step1.each do |step|
					step2 = find_possible_routes(step[:ends], stop)
				end
			end
			return step2
		end

end