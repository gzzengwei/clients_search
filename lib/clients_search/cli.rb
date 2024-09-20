# frozen_string_literal: true

module ClientsSearch
  class CLI
    attr_reader :repository

    def initialize(repository:)
      @repository = repository
    end

    def call(args)
      command = args[0]
      field = args[1]
      query = args[2]

      case command
      when "search"
        search(field, query)
      when "find_duplicates"
        find_duplicates(field)
      else
        puts "Invalid commands."
      end
    end

    private

    def search(field, query)
      result = repository.search(field: field, query: query)

      if result.empty?
        puts "No clients match for #{query} on #{field}."
      else
        puts "Matched clients for #{query} on #{field}:"
        result.each { |client| puts client }
      end
    end

    def find_duplicates(field)
      result = repository.find_duplicates(field: field)

      if result.empty?
        puts "No duplicate clients on #{field}"
      else
        puts "Duplicate clients on #{field}:"
        result.each do |key, group|
          puts "for #{key}:"
          group.each { |client| puts client }
        end
      end
    end
  end
end
