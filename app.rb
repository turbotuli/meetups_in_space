require 'sinatra'
require_relative 'config/application'
require 'pry'

set :bind, '0.0.0.0'  # bind to all interfaces

helpers do
  def current_user
    if @current_user.nil? && session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
      session[:user_id] = nil unless @current_user
    end
    @current_user
  end
end

get '/' do
  redirect '/meetups'
end

get '/auth/github/callback' do
  user = User.find_or_create_from_omniauth(env['omniauth.auth'])
  session[:user_id] = user.id
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/meetups' do
  if Meetup.all != []
    @meetups = Meetup.all.sort_by {|meetup| meetup.name }
  end
  erb :'meetups/index'
end

get '/meetups/new' do
  if session[:user_id].nil?
    flash[:notice] = "Please sign in!"
    redirect '/meetups'
  end

  erb :'meetups/new'
end

get '/meetups/:id' do
  @meetup = Meetup.where(id: params[:id]).first
  @creator = @meetup.user.username
  @attendees = @meetup.attendees
  @join = true if !@attendees.pluck(:user_id).include?(session[:user_id])
  @leave = true if @attendees.pluck(:user_id).include?(session[:user_id])
  @edit = true if @meetup.creator_id == session[:user_id]

  erb :'meetups/view'
end

post '/meetups' do
  meetup = Meetup.new(
            creator_id: session[:user_id],
            name: params[:name],
            location: params[:location],
            description: params[:description],
            date: params[:date]
          )
  if meetup.valid?
      meetup.save
      flash[:notice] = "Meetup created!"
      redirect '/meetups'
  else
    meetup.valid?
    @errors = meetup.errors.full_messages
    @name = params[:name]
    @location = params[:location]
    @description = params[:description]
    @date = params[:date]

    erb :'/meetups/new'
  end
end

post '/meetups/:id' do
  user_included = Attendee.where(meetup_id: params[:id]).pluck(:user_id).include?(session[:user_id])
  if session[:user_id].nil?
    flash[:notice] = "Please sign in!"
  elsif !user_included
    Attendee.create(meetup_id: params[:id], user_id: session[:user_id])
    flash[:notice] = "You have joined the meetup!"
  elsif user_included
    attendee = Attendee.where(["user_id = ? AND meetup_id = ?", session[:user_id], params[:id].to_i])
    attendee.first.delete
    flash[:notice] = "You have left the meetup."
  end
  redirect '/meetups/' + params[:id]
end

get '/meetups/edit/:id' do
  @meetup = Meetup.where(id: params[:id]).first
  @name = @meetup.name
  @location = @meetup.location
  @description = @meetup.description
  @date = @meetup.date

  erb :'/meetups/edit'
end

patch '/meetups/edit/:id' do
  @meetup = Meetup.where(id: params[:id]).first
  attributes = {
    name: params[:name],
    location: params[:location],
    description: params[:description],
    date: params[:date]
  }
  if @meetup.update_attributes(attributes)
    flash[:notice] = "Meetup updated!"
    redirect '/meetups/' + params[:id]
  else
    @errors = @meetup.errors.full_messages
    @name = params[:name]
    @location = params[:location]
    @description = params[:description]
    @date = params[:date]

    erb :'/meetups/edit'
  end
end

delete '/meetups/:id' do
  Meetup.where(id: params[:id]).first.delete
  flash[:notice] = "Meetup deleted."

  redirect '/meetups'
end
