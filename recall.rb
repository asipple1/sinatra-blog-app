require 'rubygems'
require 'sinatra'
require 'data_mapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/recall.db")
 
class Note
  include DataMapper::Resource
  property :id, Serial
  property :content, Text, :required => true
  property :complete, Boolean, :required => true, :default => false
  property :created_at, DateTime
  property :updated_at, DateTime
end
 
DataMapper.finalize.auto_upgrade!

get '/' do
    @notes = Note.all :order => :id.desc #retrieve all notes from data base
    @title ='all Notes' #Set the @title instance variable and load views/home.erb
    erb :home
    end
# redirects you back to main recall page once you hit button where the info will be displayed
post '/' do
  n = Note.new
  n.content = params[:content]
  n.created_at = Time.now
  n.updated_at = Time.now
  n.save
  redirect '/'
end
# opens edit.erb file so we can edit post
    get '/:id' do
  @note = Note.get params[:id]
  @title = "Edit note ##{params[:id]}" #retrieve requested note and setup var called @ title
  erb :edit
end
# puts the new info that has been edit
put '/:id' do
  n = Note.get params[:id]
  n.content = params[:content]
  n.complete = params[:complete] ? 1 : 0
  n.updated_at = Time.now
  n.save
  redirect '/'
end
#this deletes the post
get '/:id/delete' do
  @note = Note.get params[:id]
  @title = "Confirm deletion of note ##{params[:id]}"
  erb :delete # looking for delete.erb file
end
 delete '/:id' do
     n=Note.get params[:id]
     n.destroy
     redirect'/'
     end
get '/:id/complete' do
  n = Note.get params[:id]
  n.complete = n.complete ? 0 : 1 # flip it
  n.updated_at = Time.now
  n.save
  redirect '/'
end