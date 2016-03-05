#Requiring the important filed
require 'sinatra'
require 'sinatra/reloader' if development?
require 'byebug' if development?
require 'json'

require './database'

#Routes for Lists
get "/" do
  @lists = List.all
  erb :index
end

#SHOW all tasks on a given list
get "/lists/:id" do
  #@list will persist into the view
  @list = List.where("id = ?", params["id"]).first

  #render /views/list.erb
  erb :list
end

#CREATE a list with the given params
post "/lists" do
  list = List.new name: params["name"]
  List.insert(list) if list.valid?
  list = List.where("name = ?", list.name).first

  redirect "/lists/#{list.id}"
end

delete "/lists/:id" do
  List.where("id = ?", params[:id]).first.delete
  
  redirect "/"
end

#Routes for Tasks
post "/tasks" do
  task = Task.new task: 
    params["name"], 
    completed: 0, 
    list_id: params["id"]

  Task.insert(task) if task.valid?
  task = Task.where("task = ? AND list_id = ?", task.task, task.list_id)

  redirect "/lists/#{params["id"]}"
end

put "/tasks/:id" do
  task = Task.where("id = ?", params["id"]).first
  if params["#{task.id}"] == "on"
    task.completed = true
  else
    task.completed = false
  end
  task.save

  redirect "/lists/#{task.list_id}"
end

delete "/tasks/:id" do
  task = Task.where("id = ?", params["id"])
  task.delete
end
