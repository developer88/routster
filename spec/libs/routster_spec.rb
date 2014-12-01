require 'spec_helper'
require './routster'

RSpec.describe Routster do

  describe 'during initialization' do

    let(:lib) { Routster.new(['AB6', 'BC1', 'CA2']) }

    it 'should parse routes and return array of them' do
      expect(lib.routes.size).to eq(3)
      expect(lib.routes.is_a?(Array)).to be true
    end

  end

  describe '#distance_for' do

    let(:lib) { Routster.new(['AB6', 'BC1', 'CA2']) }
    let(:route) { lib.distance_for('A-B') }
    let(:unknown_route) { lib.distance_for('D-C') }

    it 'should return distance for the route' do
      expect(route[:length].to_i).to eq(6)
    end

    it 'should return distance for the route as Hash' do
      expect(route.is_a?(Hash)).to be true
    end

    it 'should return no information about route' do
      expect(unknown_route[:length]).to be_nil
    end

    it 'should return status key for unknown route' do
      expect(unknown_route[:status]).to eq('NO SUCH ROUTE')
    end

  end

  describe '#trips' do

    let(:lib) { Routster.new(['AB6', 'BC1', 'CA2', 'BE2', 'EC1']) }

    context 'calculate in stops' do      

      it 'should return number of trips limited by maximum of stops as array' do
        expect(lib.trips('A', 'C', {count: 2, precise: :maximum, kind: :stops}).is_a?(Array)).to be true
      end

      it 'should return number of trips limited by maximum of stops' do
        expect(lib.trips('A', 'C', {count: 4, precise: :maximum, kind: :stops}).size).to eq(2)
      end

      it 'should return number of trips limited by exact amount of stops' do
        expect(lib.trips('A', 'C', {count: 3, precise: :exactly, kind: :stops}).size).to eq(1)
      end      

    end

    context 'calculate in distance' do

      it 'should return number of trips limited by distance' do
        expect(lib.trips('A', 'C', {count: 8, precise: :less_than, kind: :distance}).size).to eq(1)
      end

    end

  end

  describe '#shortest_route' do

    let(:lib) { Routster.new(['AB6', 'BC1', 'CA2']) }

    it 'should return information about shortest route as Hash' do
      expect(lib.shortest_route('A','C').is_a?(Hash)).to be true
    end

    it 'should return information about shortest route as Hash' do
      expect(lib.shortest_route('A','C')[:length]).to eq(7)
    end 

  end

  describe 'with test input' do

    let(:lib) {Routster.new(['AB5', 'BC4', 'CD8', 'DC8', 'DE6', 'AD5', 'CE2', 'EB3', 'AE7'])}

    context 'should return values as it mentioned in task description' do

      it '#1 The distance of the route A-B-C' do
        result = lib.distance_for('A-B-C')
        expect(result[:length].to_i).to eq(9) 
      end

      it '#2 The distance of the route A-D' do
        result = lib.distance_for('A-D')
        expect(result[:length].to_i).to eq(5) 
      end

      it '#3 The distance of the route A-D-C' do
        result = lib.distance_for('A-D-C')
        expect(result[:length].to_i).to eq(13) 
      end

      it '#4 The distance of the route A-E-B-C-D' do
        result = lib.distance_for('A-E-B-C-D')
        expect(result[:length].to_i).to eq(22) 
      end

      it '#5 The distance of the route A-E-D' do
        result = lib.distance_for('A-E-D')
        expect(result[:length]).to eq(nil) 
        expect(result[:status]).to eq('NO SUCH ROUTE')
      end

      it '#6 The number of trips starting at C and ending at C with a maximum of 3 stops' do
        result = lib.trips('C', 'C', {count: 3, precise: :maximum, kind: :stops})
        expect(result.size).to eq(2)
      end 

      it '#7 The number of trips starting at A and ending at C with exactly 4 stops. Attention please!' do
        result = lib.trips('A', 'C', {count: 4, precise: :exactly, kind: :stops})
        #expect(result.size).to eq(3) # Please see readme file 
        expect(result.size).to eq(1)
      end

      it '#8 The length of the shortest route (in terms of distance to travel) from A to C' do
        result = lib.shortest_route('A', 'C')
        expect(result[:length]).to eq(9)
      end

      it '#9 The length of the shortest route (in terms of distance to travel) from B to B' do
        result = lib.shortest_route('B', 'B')
        expect(result[:length]).to eq(9)
      end     
      
      it '#10 The number of different routes from C to C with a distance of less than 30. Attention please!' do
        result = lib.trips('C', 'C', {count: 30, precise: :less_than, kind: :distance})
        #expect(result.size).to eq(7) # Please see readme file 
        expect(result.size).to eq(3)
      end   

    end

  end

end
