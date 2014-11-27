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

  end

  describe '#trips' do

    context 'calculate in stops' do

    end

    context 'calculate in distance' do

    end

  end

  describe '#shortest_route' do

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

    it 'should return values as it mentioned in task description' do

    end

  end

end