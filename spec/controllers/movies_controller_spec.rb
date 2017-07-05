require 'rails_helper'

describe MoviesController do
    describe 'Searching movies by director' do
        before :each do
            @fake_results = [double('movie1'), double('movie2')]
        end
        it 'calls model method that search all the movies by director' do
            expect(Movie).to receive(:search_movies_by_director).with('1').and_return(@fake_results)
            post :search, {:id => 1}
        end
        describe 'After valid search' do
            before :each do
                allow(Movie).to receive(:search_movies_by_director).with('1').and_return(@fake_results)
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
    
    describe 'Checking correct Restful route for search by director' do
        it 'search link/button should generate correct URI' do
            #:search_movies{:director => 'Ridley Scott'}
            #expect(URI.parse(response.location)).to eq search_movies_path
        end
        
    end
end
