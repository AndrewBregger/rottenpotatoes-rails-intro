class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # this will be changed later
    @all_ratings = Movie.ratings
    @movies = Movie.all
    rates = params[:ratings]
    # maybe this will save the last instance
    @marked = {}
    
    @all_ratings.each do |rating|
      @marked[rating] = false
    end
    
    if rates
      rates.keys.each do |rating| 
        @marked[rating] = true
      end
      
      @movies = @movie.where(:rating => rates.keys)
    else
      @movies = @movie.where(:rating => {})
    end
    
    sorts = params[:sort]
    
    if sorts
      @movies = @movies.order(sorts)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
end