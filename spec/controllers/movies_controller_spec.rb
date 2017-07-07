require 'rails_helper'

describe MoviesController do
    describe 'Searching movies by director' do
        context 'the specified movie has no director' do
            before :each do
                @movie = double('movie',:id => 1,:director => nil)
            end
            it 'calls model method to retrieve movie details with no director' do
                expect(Movie).to receive(:find).with(1).and_return(@movie)
                expect(Movie.find(1)).to eq(@movie)
                expect(@movie.director).to be_nil
            end
        end
        context 'specified movie has director' do
            before :each do
                @fake_results = [double('movie1'), double('movie2')]
                @movie = double('movie',:id => '1',:director => 'George Lucas')
                allow(Movie).to receive(:find).with('1').and_return(@movie)
            end
            it 'calls model method to retrieve movie details with director "George Lucas"' do
                #expect(Movie).to receive(:find).with(1).and_return(@movie)
                expect(Movie.find('1')).to eq(@movie)
                expect(@movie.director).to eq ("George Lucas")
            end
            it 'calls model method that search all the movies by director' do
                expect(Movie).to receive(:search_movies_by_director).with('George Lucas').and_return(@fake_results)
                post :search, {:id => 1}
            end
            describe 'After valid search' do
                before :each do
                    allow(Movie).to receive(:search_movies_by_director).with('George Lucas').and_return(@fake_results)
                    post :search, {:id => 1}
                end
                it 'selects view that displays search result' do
                    expect(response).to render_template('search')
                end
                it 'makes search result available to view' do
                    expect(assigns(:movies)).to eq(@fake_results)
                end
            end
       end
    end
end
