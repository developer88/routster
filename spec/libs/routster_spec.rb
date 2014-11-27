require 'spec_helper'
require './routster'

RSpec.describe Routster do

  describe 'initialization' do

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
      expect(route[:length]).to eq(6)
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

    context 'calculate in stops' do

      let(:lib) { Routster.new(['AB6', 'BC1', 'CA2']) }

      it 'should return number of trips limited by maximum of stops as array' do
        expect(lib.trips(starts: 'A', ends: 'C', count: 3, precise: :maximum, kind: :stops).is_a?(Array)).to be true
      end

      it 'should return number of trips limited by maximum of stops' do
        expect(lib.trips(starts: 'A', ends: 'C', count: 3, precise: :maximum, kind: :stops).size).to eq(2)
      end

      it 'should return number of trips limited by exact amount of stops' do
        expect(lib.trips(starts: 'A', ends: 'C', count: 1, precise: :exactly, kind: :stops).size).to eq(1)
      end      

    end

    context 'calculate in distance' do

      it 'should return number of trips limited by distance' do
        expect(lib.trips(starts: 'A', ends: 'C', count: 8, precise: :less_than, kind: :distance).size).to eq(1)
      end

    end

  end

  describe '#shortest_route' do

    let(:lib) { Routster.new(['AB6', 'BC1', 'CA2']) }

    it 'should return information about shortest route as Hash' do
      expect(lib.shortest_route('A-C').is_a?(Hash)).to be true
    end

    it 'should return information about shortest route as Hash' do
      expect(lib.shortest_route('A-C')[:length]).to eq(7)
    end 

  end

  describe 'with test input' do

    let(:lib) {Routster.new(['AB5', 'BC4', 'CD8', 'DC8', 'DE6', 'AD5', 'CE2', 'EB3', 'AE7'])}

    context 'should return values as it mentioned in task description' do

      it 'for distances (from 1 to 5)' do
        [['A-B-C', 9], ['A-D', 5], ['A-D-C', 13], ['A-E-B-C-D', 22], ['A-E-D', nil]].each do |route|
          result = lib.distance_for(route[0])
          expect(result[:length]).to eq(route[1]) 
          expect(result[:status]).to eq('NO SUCH ROUTE') if route[1].nil?
        end
      end

      it 'for number of trips (from 6 to 7, and for 10)' do
        [['C', 'C', 3, :maximum, :stops, 2], ['A', 'C', 4, :exactly, :stops, 3], ['C', 'C', 30, :less_than, :distance, 7]].each do |route|
          result = lib.trips(starts: route[0], ends: route[1], count: route[2], precise: route[3], kind: route[4])
          expect(result.size).to eq(route[5])
        end
      end

      it 'for length of the shortest route (from 8 to 9)' do
        [ ['A-C', 9], ['B-B', 9] ].each do |route|
          result = lib.shortest_route(route[0])
          expect(result[:length]).to eq(route[1])
        end
      end

    end

  end

end