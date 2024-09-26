# frozen_string_literal: true

require "sinatra"
require "json"
require_relative "lib/clients_search"

class ClientsSearchApp < Sinatra::Base
  before do
    content_type :json
  end

  set :port, 3000

  def initialize
    super
    @repository = ClientsSearch::Repository.new(clients: clients)
  end

  get "/query" do
    query = params[:q]
    field = params[:field] || "full_name"

    results = @repository.search(field: field, query: query)

    {results: results}.to_json
  end

  get "/find_duplicates" do
    field = params[:field] || "email"
    duplicates = @repository.find_duplicates(field: field)

    {duplicates: duplicates}.to_json
  end

  not_found do
    status 404
    {error: "Not Found"}.to_json
  end

  private

  def clients
    ClientsSearch::Parser.call(file_path: json_file)
  end

  def json_file
    File.join(File.dirname(__FILE__), "spec", "data", "clients.json")
  end

  run! if app_file == $0
end
