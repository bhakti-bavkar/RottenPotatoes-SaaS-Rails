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
    describe 'Searching movie in TMDb' do
        context 'with valid API key' do
            it 'fetches valid search result' do
                expect(Tmdb::Movie).to receive(:find).with('test_movie')
                expect { Movie.find_in_tmdb('test_movie') }.not_to raise_error
             end    
        end
        context 'with invalid API key' do
            it 'raises an InvalidKeyError' do
                expect(Tmdb::Movie).to receive(:find).and_raise(Tmdb::InvalidApiKeyError)
                expect { Movie.find_in_tmdb('test_movie') }.
                to raise_error(Movie::InvalidKeyError)
            end
            
        end
    end
end