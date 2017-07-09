require 'rails_helper'

describe MoviesController do
    describe 'Searching movies by director' do
        context 'the specified movie has no director' do
            before :each do
                @movie = FactoryGirl.build(:movie, :title => 'Star Wars', :director => '')
            end
            it 'calls model method to retrieve movie details' do
                expect(Movie).to receive(:find).with('1').and_return(@movie)
                get :search, {:id => 1}
            end
            describe 'After Valid Search' do
                before :each do
                    allow(Movie).to receive(:find).with('1').and_return(@movie)
                    get :search, {:id => 1}
                end
                it 'found with no director' do
                    expect(@movie.director).to eq('')
                end
                it 'response should redirect to home page' do
                    expect(response).to redirect_to('/movies')
                end
            end
        end
        context 'specified movie has director' do
            before :each do
                @fake_results = [double('movie1'), double('movie2')]
                @movie = FactoryGirl.build(:movie, :title => 'Star Wars', :director => 'George Lucas')
            end
            it 'calls model method to retrieve movie details with director "George Lucas"' do
                expect(Movie).to receive(:find).with('1').and_return(@movie)
                get :search, {:id => 1}
            end
            describe 'found movie with director' do
                before :each do
                    allow(Movie).to receive(:find).with('1').and_return(@movie)
                    get :search, {:id => 1}
                end
                it 'and director is "George Lucas"' do
                    expect(@movie.director).to eq('George Lucas')
                end
                it 'calls model method that search all the movies by director' do
                    expect(Movie).to receive(:search_movies_by_director).with('George Lucas').and_return(@fake_results)
                    get :search, {:id => 1}
                end
                describe 'After valid search' do
                    before :each do
                        allow(Movie).to receive(:search_movies_by_director).with('George Lucas').and_return(@fake_results)
                        get :search, {:id => 1}
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
    describe 'show movie details' do
        before :each do
            @fake_movie = double('movie', :id => 1)
        end
        it 'calls model method to find movie details' do
            expect(Movie).to receive(:find).with('1').and_return(@fake_movie)
            get :show , :id => 1
        end
        describe 'After valid search' do
            before :each do
                allow(Movie).to receive(:find).with('1').and_return(@fake_movie)
                get :show , :id => 1
            end
            it 'selects view that displays details' do
                expect(response).to render_template('show')
            end
            it 'makes result available to view' do
                expect(assigns(:movie)).to eq(@fake_movie)
            end
        end
    end
    describe 'new movie' do
       it 'selects view that displays details' do
            get :new
            expect(response).to render_template('new')
        end
    end
    describe 'create a movie' do
        before :each do
            @movie = FactoryGirl.build(:movie)
            @movie_attributes = FactoryGirl.attributes_for(:movie)
        end
        it 'creates a new movie with details' do
           expect{post :create, :movie => @movie_attributes}.to change(Movie,:count).by(1)
        end  
        it 'redirects to home page' do
            post :create, :movie => @movie_attributes
            expect(flash[:notice]).to eq "#{@movie.title} was successfully created."
            expect(response).to redirect_to movies_path
        end
    end
    describe 'edit movie details' do
        before :each do
            @fake_movie = double('movie', :id => 1)
        end
        it 'calls model method to find movie details' do
            expect(Movie).to receive(:find).with('1').and_return(@fake_movie)
            get :edit , :id => 1
        end
        describe 'After valid search' do
            before :each do
                allow(Movie).to receive(:find).with('1').and_return(@fake_movie)
                get :edit , :id => 1
            end
            it 'selects view that displays details' do
                expect(response).to render_template('edit')
            end
            it 'makes result available to view' do
                expect(assigns(:movie)).to eq(@fake_movie)
            end
        end
    end
    describe 'update movie details' do
        before :each do
            @movie = FactoryGirl.build(:movie)#default movie attributes
            @movie_attributes = FactoryGirl.attributes_for(:movie)
            @new_movie_attributes = FactoryGirl.attributes_for(:movie,:rating => "PG-13", :description => "random")
        end
        it 'calls model method to retrieve movie details' do
            expect(Movie).to receive(:find).with('1').and_return(@movie)
            put :update, :id => 1, :movie => @movie_attributes
            expect(assigns(:movie)).to eq(@movie)
        end
        describe 'After lacating requested movie' do
            before :each do
                allow(Movie).to receive(:find).with('1').and_return(@movie)
                put :update, :id => 1, :movie => @new_movie_attributes
            end
            it "changes to updated movie details" do
                expect(@movie.rating).to eq("PG-13")
                expect(@movie.description).to eq("random")
            end
            it 'redirects to home page' do
                expect(flash[:notice]).to eq "#{@movie.title} was successfully updated."
                expect(response).to redirect_to movie_path
            end
        end
    end
    describe 'delete a movie' do
        before :each do
            @movie = FactoryGirl.create(:movie)
        end
        it 'calls model method to find movie details' do
            expect(Movie).to receive(:find).with('1').and_return(@movie)
            expect{delete :destroy, :id => 1}.to change(Movie,:count).by(-1)
        end  
        it 'redirects to home page' do
            allow(Movie).to receive(:find).with('1').and_return(@movie)
            delete :destroy, :id => 1
            expect(flash[:notice]).to eq "Movie '#{@movie.title}' deleted."
            expect(response).to redirect_to movies_path
        end
    end
    describe 'index-list of movies' do
        before :each do
            @fake_results = [double('movie1'),double('movie2')]
        end
        it 'calls model method to find list of movies with given sorting and filter contraints' do
            expect(Movie).to receive_message_chain(:where,:order).and_return(@fake_results)
            get :index
        end
        it 'makes result available to view' do
            allow(Movie).to receive_message_chain(:where,:order).and_return(@fake_results)
            get :index
            expect(assigns(:movies)).to eq(@fake_results)
        end
    end
end
