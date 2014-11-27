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


		puts "The distance of the route " if print
	end

	def trips

	end

	def shortest_route(route, print = false)

		puts "The length of the shortest route from to is " if print
	end

	private 

		def parse_routes(routes)
			routes.each do |route|
				@routes << {starts: route[0], ends: route[1], length: route[2..route.size]}
			end
		end

end