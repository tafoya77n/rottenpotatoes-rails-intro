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
    if(params.has_key?(:sort))
      sort = params[:sort]
      if(sort=='release_date'||sort=='title')
        session[:sort]=sort
      end
    else
      sort=session[:sort]
    end
    
    if(!session[:ratings])
      session[:ratings]={'G'=>1,'PG'=>1,'PG-13'=>1,'R'=>1,'NC-17'=>1}
    end
        
    if(params.has_key?(:ratings))
      ratings=params[:ratings]
      if(ratings.empty?)
        ratings=session[:ratings]
      end
    else
      ratings=session[:ratings]
    end
    
    if (sort=='release_date'||sort=='title')
      movies=Movie.where('rating in (?)',ratings.keys).order(sort)
    else
      movies=Movie.where('rating in (?)',ratings.keys)
    end
    
    session[:ratings]=ratings
    
    @checked_ratings=ratings.keys
    @movies=movies
    @sort=sort
    @all_ratings=Movie.all_ratings
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
