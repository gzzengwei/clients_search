# frozen_string_literal: true

require "json"
require "logger"
require "sinatra"
require_relative "lib/clients_search"

class ClientsSearchApp < Sinatra::Base
  before do
    content_type :json
  end

  set :port, 3000

  def initialize
    super
    @repository = ClientsSearch::Repository.new(clients: clients)
    @cache = ClientsSearch::Cache.new
    @logger = Logger.new($stdout)
  end

  get "/query" do
    query = params[:q]
    field = params[:field] || "full_name"

    results = @cache.get("#{field}:#{query.downcase}")
    if results.nil?
      results = @repository.search(field: field, query: query)

      @logger.info("saving result to cache for #{"#{field}:#{query.downcase}"}")
      @cache.set("#{field}:#{query.downcase}", results)
    else
      @logger.info("fetching from cache for #{"#{field}:#{query.downcase}"}")
    end

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
