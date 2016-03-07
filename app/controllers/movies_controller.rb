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
      if (sort=='title')
        sort='title'
      elsif(sort=='date')
        sort='release_date'
      else
        sort='none'
      end
    else
      sort='none'
    end
    if(params.has_key?(:ratings))
      ratings= params[:ratings]
      if (sort!='none')
        movies=Movie.where('rating in (?)',ratings.keys).order(sort)
      else
        movies=Movie.where('rating in (?)',ratings.keys)
      end
      checked_ratings=ratings.keys
    else
      movies=Movie.all
      checked_ratings=Movie.all_ratings
    end
    
    @checked_ratings=checked_ratings
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
