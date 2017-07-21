class MoviesController < ApplicationController
  
  before_action :get_settings, :only => :index
  before_action :require_login, :only => [:new, :edit, :destroy]
  
  after_action :set_settings, :only => :index
  #skip_before_action :set_current_user, :only => [:index]

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :director)
  end
  
  def search
    @movie = Movie.find(params[:id])
    if @movie.director.blank?
      #flash[:notice] = "'#{@movie.title}' has no director info"
      redirect_to movies_path, :flash => { :notice => "'#{@movie.title}' has no director info"}
    end
    @movies = Movie.search_movies_by_director(@movie.director)
  end

  def show
    # retrieve movie ID from URI route
    @movie = Movie.find(params[:id]) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params[:column].nil? and params[:ratings].nil?
      params[:column] = session[:sort]
      params[:ratings] = session[:filter]
      flash.keep
      redirect_to movies_path(:ratings => params[:ratings],:column => params[:column])
    end
    @all_ratings = Movie.all_ratings
    params[:ratings] = session[:filter] if params[:ratings].nil? #all filters are uncehecked
    params[:column] = session[:sort] if params[:column].nil?
    @selected_ratings = params[:ratings].keys
    @title_header = 'hilite' if params[:column] == 'title'
    @release_date_header = 'hilite' if params[:column] == 'release_date'
    @movies = Movie.filter_and_sort(params[:ratings],params[:column])
   end

  def new
    # default: render 'new' template
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    else
      render 'new'
    end
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    if @movie.update_attributes(movie_params)
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    else
      render 'edit'
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
    
  private
  def get_settings
    settings = Movie.default_settings
    session[:filter] ||= settings[:ratings]
    session[:sort] ||= settings[:column]
  end
  
  def set_settings
    session[:filter] = params[:ratings] unless params[:ratings].nil?
    session[:sort] = params[:column] unless params[:column].nil?
  end
  
  def require_login
    unless @current_user
    redirect_to login_path, :flash => { :warning => "You must be logged in to access this section"} 
    end
  end
end
