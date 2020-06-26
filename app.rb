# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require "json"
require "securerandom"

class Memo
  def self.find(id: memo_id)
    JSON.parse(File.read("memos/#{id}.json"))
  end

  def self.create(title: memo_title, body: memo_body)
    memo_info = { id: SecureRandom.uuid, title: title, body: body }
    File.open("memos/#{memo_info[:id]}.json", "w") { |f| f.puts JSON.pretty_generate(memo_info) }
  end

  def edit(id: memo_id, title: memo_title, body: memo_body)
    memo_info = { id: id, title: title, body: body }
    File.open("memos/#{memo_info[:id]}.json", "w") { |f| f.puts JSON.pretty_generate(memo_info) }
  end

  def destroy(id: memo_id)
    File.delete("memos/#{id}.json")
  end
end

get "/memos" do
  files = Dir.glob("memos/*").sort_by { |f| File.mtime(f) }
  @memos = files.map do |file|
    JSON.parse(File.read(file))
  end
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
  @memo_data = Memo.find(id: params[:id])
  erb :show
end

get "/memos/:id/edit" do
  @memo_data = Memo.find(id: params[:id])
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
