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
    @all_ratings = Movie.ratings
    @title_class = nil
    @release_class = nil
    
    if params[:sort]
      session[:sort] = params[:sort]
    end
    
    if params[:ratings]
      session[:ratings] = params[:ratings]
    end
    
    if (params[:sort].nil? and !session[:sort].nil?) or
       (params[:ratings].nil? and !session[:ratings].nil?)
       
      flash.keep
      redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
    end
    
    if session[:ratings].nil?
      @selected_ratings = @all_ratings
    else
      @selected_ratings = session[:ratings].keys
    end
    
    if session[:sort] == "title"
      @title_class = "hilite"
    elsif session[:sort] == "release_date"
      @release_class = "hilite"
    end
    
    if !session[:ratings].nil?
      @movies = Movie.order(session[:sort]).where(:rating => session[:ratings].keys)
    else
      @movies = Movie.order(session[:sort])
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