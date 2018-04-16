class Api::V1::UsersController < ApplicationController

  # before_action :authorize!, only: [:users_following]
  skip_before_action :authenticate!, only: [:index, :create]

  def index
    @users = User.all
    render json: @users
  end

  def create
    @user = User.new(name: params[:name], email: params[:email], password: params[:password])
    if @user.save
      render json: user_json(@user)
    else
      render json: { errors: @user.errors.full_messages }, :status => :unprocessable_entity
    end
  end



  def show
    unless authorized?
      render json: { take_a_hike: true}
    else
      @user = User.find_by(id: params[:user_id])
      if @user
        render json: @user
      else
        render json: true, :status => :not_found
      end
    end
  end

  def users_followers
    unless authorized?
      render json: { take_a_hike: true}
    else
      @user = User.find_by(id: params[:user_id])
      if @user
        render json: @user.followers
      else
        render json: true, :status => :not_found
      end
    end
  end

  def users_following
    unless authorized?
      render json: { take_a_hike: true}
    else
      @user = User.find_by(id: params[:user_id])
      if @user
        render json: @user.following
      else
        render json: true, :status => :not_found
      end
    end
  end


  def itinerary_activities
    unless authorized?
      render json: { take_a_hike: true}
    else
      @user = User.find_by(id: params[:user_id])
      @itinerary = @user.itineraries.find_by_id(params[:itinerary_id])
      if @itinerary
        render json: @itinerary.activities
      else
        render json: true, :status => :not_found
      end
    end
  end

  def users_itineraries
    unless authorized?
      render json: { take_a_hike: true}
    else
      @user = User.find_by(id: params[:user_id])
      if @user
        render json: @user.itineraries
      else
        render json: true, :status => :not_found
      end
    end
  end

  def create_user_itinerary
    @user = User.find_by_id(params[:user_id])
    @itinerary = Itinerary.create(name: params[:name])
    @newTrip = UserItinerary.new(user_id: @user.id, itinerary_id: @itinerary.id)
    if @newTrip.save
      render json: @user.itineraries
    else
      render json: true, :status => :not_found
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
end
