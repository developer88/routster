class Routster

  attr_reader :routes

  def initialize(routes = [])
    @routes = []
    parse_routes(routes)
  end

  # Find distance for simple route like A-C
  def distance_for(route)
    stops = route.split('-')
    routes = find_direct_routes(stops)
    length = (routes.length == (stops.size - 1) ? routes.map{ |r| r[:length] }.inject{ |sum,x| sum + x } : nil)
    { status: (length.nil? ? 'NO SUCH ROUTE' : nil), length: length }
  end

  # Find all possible direct trips 
  #
  # params:
  # precise - can be: :maximum, :exactly, :less_than
  # kind - filter by :stops or :distance
  # count - value for filtering
  def trips(start, stop, params = {})
    params = {precise: :exactly, kind: :stops, count: 3}.merge(params)
    routes_arr = routes_finder(start, stop)
    # Now we have beautifull array of hashes with some statistic
    # We should filter found routes and finally return the results
    field = (params[:kind] == :distance ? :length : :stops)
    routes_arr.keep_if{|route| route[field] == params[:count] } if params[:precise] == :exactly
    routes_arr.keep_if{|route| route[field] <= params[:count] } if params[:precise] == :maximum
    routes_arr.keep_if{|route| route[field] < params[:count] } if params[:precise] == :less_than
    routes_arr
  end

  # Find the shortest route between stops
  def shortest_route(start, stop)
    routes_finder(start, stop).sort_by {|route| route[:length]}.first	
  end

  private 

  # Parse routes passed from command line and store them in hashes
  def parse_routes(routes)
    routes.each do |route|
      @routes << { code: route, starts: route[0], ends: route[1], length: route[2..route.size].to_i }
    end
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
  def routes_finder(start, stop)
    raw_routes = find_possible_routes(start, stop)
    # Now we have array with complete routes and unfinished routes.
    # Lets convert it to string and calculate overall length and get rid of unfinished routes
    sort_out_raw_route(raw_routes).map do |route|
      { 
      	route: route.map{|r| r[:code]}, 
      	stops: route.map{|r| [r[:code][0], r[:code][1]]}.flatten.uniq.size, 
        length: route.map{|r| r[:length].to_i}.inject{|sum,x| sum + x } 
      }
    end
  end

  # I suppose there will not be cases when there will be duplicates routes with different lengths,
  #   for example AD5, CD3, AD1, AD3 etc
  #
  # In the result there will be nested hash
  def find_possible_routes(start, stop, route = {}, routes_arr = @routes.dup, iteration = 0)
    iteration += 1
    return route if iteration > 10 # Some ugly hack to limit iterations
    # Find all routes that starts from 'start' point
    starts_points = routes_arr.select { |r| r[:starts] == start }
    # Try to filter all the routes that end with 'stop' point
    starts_points.select { |r| r[:ends] == stop }.each do |point|
      route["#{point[:starts]}#{point[:ends]}#{point[:length]}"] = {} # add this point to the route
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
  #   for example AB4 to {code: 'AB4', starts: 'A' ....}
  #
  # In the result there will be array
  def sort_out_raw_route(raw_routes)
    result = []
    find_route = ->(route){ @routes.find{ |r| r[:code] == route } }

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
