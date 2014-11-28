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

	# Find distance for simple route like A-C
	def distance_for(route, print = false)
		stops = parse_stops(route)
		routes = find_direct_routes(stops)
		length = routes.length == (stops.size - 1) ? routes.map{|r| r[:length]}.inject{|sum,x| sum + x } : nil
		status = length == nil ? 'NO SUCH ROUTE' : nil
		puts "The distance of the route #{route} is #{length} #{status != nil ? "because #{status}" : ""}" if print
		{status: status, length: length}
	end

	# Find all possible direct trips 
	#
	# params:
	# starts 
	# ends
	# precise - can be: :maximum, :exactly, :less_than
	# kind - filter by :stops or :distance
	# count - value for filtering
	def trips(*args)
		routes_finder(args[0][:starts], args[0][:ends], args[0][:precise], args[0][:kind], args[0][:count])
	end

	# Find the shortest route between stops
	def shortest_route(start, stop, print = false)
		route = routes_finder(start, stop, nil, nil, nil, 'shortest')
		puts "The length of the shortest route from #{start} to #{stop} is #{route[:length]}" if print
		route
	end

	private 

		# Parse routes from command line and store them in hashes
		def parse_routes(routes)
			routes.each do |route|
				@routes << {code: route, starts: route[0], ends: route[1], length: route[2..route.size].to_i}
			end
		end

		# Converts route from command line to stops e.g. A-C to [A, C]
		def parse_stops(route)
			route.split('-')
		end

		# Find simple routes like A-C-D
		def find_direct_routes(stops)
			result = []
			stops.each_with_index do |stop, index|
				next if index + 1 == stops.size
				result << @routes.find {|r| r[:starts] == stop && r[:ends] == stops[index + 1] }
			end
			result.flatten.compact
		end

		# Method to find routes based on sertain params
		def routes_finder(start, stop, precise = nil, kind = nil, count = nil, type = 'normal')
			raw_routes = find_possible_routes(start, stop)
			# Now we have array with complete routes and unfinished routes.
			# Lets convert it to string and calculate overall length and get rid of unfinished routes
			routes_arr = sort_out_raw_route(raw_routes)
			routes_arr.map! do |route|
				{route: route.map{|r| r[:code]}, stops: route.map{|r| [r[:code][0], r[:code][1]]}.flatten.uniq.size, length: route.map{|r| r[:length].to_i}.inject{|sum,x| sum + x }}
			end
			# Now we have beautifull array of hashes with some statistic
			# We should filter found routes and finally return the results
			if !precise.nil? && !kind.nil? && type == 'normal' && !count.nil?
				field = kind == :distance ? :length : :stops
				routes_arr.keep_if{|route| route[field] == count } if precise == :exactly
				routes_arr.keep_if{|route| route[field] <= count } if precise == :maximum
				routes_arr.keep_if{|route| route[field] < count } if precise == :less_than
			end

			# Return either fastest route or filtered array as is
			return routes_arr.sort_by {|route| route[:length]}.first if type == 'shortest'
			routes_arr
		end

		# I suppose there will not be cases when there will be duplicates routes with different lengths,
		# for example AD5, CD3, AD1, AD3 etc
		#
		# In the result there will be nested hash
		def find_possible_routes(start, stop, route = {}, routes_arr = @routes.dup, iteration = 0)
			iteration += 1
			return route if iteration > 10 # Some ugly hack to limit iterations
			# Find all routes that starts from 'start' point
			starts_points = routes_arr.select {|r| r[:starts] == start }
			# Try to filter all the routes that end with 'stop' point
			starts_points.select {|r| r[:ends] == stop }.each do |point|
				route["#{point[:starts]}#{point[:ends]}#{point[:length]}"] = {} # add this point to the route
				# delete this point from orginal routes array and current filtered array
				#routes_arr.delete(point)
				starts_points.delete(point)
			end

			# For routes left try to shift start point and start again
			starts_points.each do |point|	
		       route["#{point[:starts]}#{point[:ends]}#{point[:length]}"] = {} # add this point to route
		       # start from end point of current route and call self 
		       find_possible_routes(point[:ends], stop, route["#{point[:starts]}#{point[:ends]}#{point[:length]}"], routes_arr, iteration)
			end
			# return what has left
			route
		end

		# Convert nested hash recursively to arrays and replace string name of the route to its full hash value,
		# for example AB4 to {code: 'AB4', starts: 'A' ....}
		#
		# In the result there will be array
		def sort_out_raw_route(raw_routes)
			result = []
			find_route = ->(route){ @routes.find{|r| r[:code] == route} }

			raw_routes.keys.each do |route|
				route_parent = find_route.call(route)
				if raw_routes[route].size == 0
					result << find_route.call(route)
				else
					raw_routes[route].keys.each do |route_child|
						route_member = find_route.call(route_child)
						if raw_routes[route][route_child].size > 0
							result << [route_parent, route_member, sort_out_raw_route(raw_routes[route][route_child])].flatten
						else
							result << [route_parent, route_member]
						end
					end
				end
			end
			result
		end

end