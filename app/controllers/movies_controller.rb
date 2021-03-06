class MoviesController < ApplicationController

  #https://boiling-tor-81348.herokuapp.com/

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #debugger
    @all_ratings = Movie.ratings
    
    #set parameters to session if params are empty
    params[:sort] ||= session[:sort]
    params[:ratings] ||= session[:ratings]
    
    if params[:ratings] == nil
      params[:ratings] = @all_ratings
    end
    
    if (params[:sort] == nil)
      @movies = Movie.where({ rating: params[:ratings].keys})
    else
      @movies = Movie.where({ rating: params[:ratings].keys}).order(params[:sort])
    end
      
    if(params[:sort]== "title")
      @title_text = "hilite"
    end
    
    if(params[:sort]== "release_date")
      @release_date_text = "hilite"
    end
    
    #put params into session to store them
    session[:ratings] = params[:ratings]
    session[:sort] = params[:sort]
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
