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
    # # Personally, I didnt like the commit=Refresh in the url so this
    # # will remove it by redirecting to a page with the same data.
    # if params[:commit] == "Refresh"
    #   redirect_to movies_path(:sort => params[:sort], :ratings => params[:ratings])
    #   return
    # end
    
    @all_ratings = Movie.ratings
    
    if session[:sort] != params[:sort] and !params[:ratings].nil?
      session[:sort] = params[:sort]
    end
    
    if !params[:ratings].nil? and session[:ratings] != params[:ratings]
      if !params[:ratings].empty?
        session[:ratings] = params[:ratings]
      end
    end

    if params[:sort].nil? and params[:ratings].nil? and (!session[:sort].nil? or !session[:ratings].nil?)
      flash.keep
      redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
      # return
    end
    
    if session[:ratings].nil?
      @selected_ratings = @all_ratings
    else
      @selected_ratings = session[:ratings].keys
    end
    
    sort = session[:sort]
    if sort.nil?
      @movies = Movie.where(:rating => @selected_ratings)
    else
      @movies = Movie.where(:rating => @selected_ratings).order("#{sort} asc")
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