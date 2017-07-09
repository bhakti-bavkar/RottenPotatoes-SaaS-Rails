require 'rails_helper'

describe Movie do
    describe 'Searching movies by director' do
        before :each do
            @movie1 = FactoryGirl.build(:movie, :title => 'Star Wars', :director => 'George Lucas')
            @movie2 = FactoryGirl.build(:movie, :title => 'THX-1138', :director => 'George Lucas')
            @movie3 = FactoryGirl.build(:movie, :title => 'Blade Runner', :director => 'Ridley Scott')
            allow(Movie).to receive(:where).with(:director => 'George Lucas').and_return([@movie1,@movie2])
        end
        it 'should find movies by the same director' do
            expect(Movie.search_movies_by_director('George Lucas')).to eq ([@movie1,@movie2])
        end
        it 'should not find movies by different directors' do
            expect(Movie.search_movies_by_director('George Lucas')).not_to eq (@movie3)
        end
    end
end