# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require "pg"

class Memo
  CONNNECT = PG.connect(host: "localhost", user: "kosuke", dbname: "memos")

  def self.all_find
    CONNNECT.exec("SELECT * FROM Memo")
  end

  def self.find(id: memo_id)
    CONNNECT.exec("SELECT * FROM Memo WHERE id = '#{id}'")
  end

  def self.create(title: memo_title, body: memo_body)
    CONNNECT.exec("INSERT INTO Memo (title, body) VALUES ('#{title}', '#{body}')")
  end

  def edit(id: memo_id, title: memo_title, body: memo_body)
    CONNNECT.exec("UPDATE Memo SET title = '#{title}', body = '#{body}' WHERE id = '#{id}'")
  end

  def destroy(id: memo_id)
    CONNNECT.exec("DELETE FROM Memo WHERE id = #{id}")
  end
end

get "/memos" do
  @memos = Memo.all_find
  erb :top
end

get "/memos/new" do
  erb :new
end

post "/memos/new" do
  Memo.create(title: params[:title], body: params[:body])
  redirect to('/memos')
end

get "/memos/:id" do
  @memos = Memo.find(id: params[:id])
  erb :show
end

get "/memos/:id/edit" do
  @memos = Memo.find(id: params[:id])
  erb :edit
end

patch "/memos/:id" do
  Memo.new.edit(id: params[:id], title: params[:title], body: params[:body])
  redirect to("/memos/#{params[:id]}")
end

delete "/memos/:id" do
  Memo.new.destroy(id: params[:id])
  redirect to("/memos")
end
