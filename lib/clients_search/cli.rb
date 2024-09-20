# frozen_string_literal: true

module ClientsSearch
  class CLI
    attr_reader :repository

    def initialize(repository:)
      @repository = repository
    end

    def call(args)
      command = args[0]
      query = args[1]
      puts "command #{command} and query #{query}"

      case command
      when "search"
        search(full_name: query)
      when "find_duplicates"
        find_duplicates
      else
        puts "Invalid commands."
      end
    end

    private

    def search(full_name:)
      result = repository.search(full_name: full_name)

      if result.empty?
        puts "No clients match for #{full_name}"
      else
        puts "Matched clients for #{full_name}:"
        result.each { |client| puts client }
      end
    end

    def find_duplicates
      result = repository.find_duplicates

      if result.empty?
        puts "No duplicate clients"
      else
        puts "Duplicate clients:"
        result.each do |key, group|
          puts "for #{key}:"
          group.each { |client| puts client }
        end
      end
    end
  end
end
