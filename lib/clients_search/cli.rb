# frozen_string_literal: true

require "json"

module ClientsSearch
  class CLI
    attr_reader :clients

    def initialize(file_path:)
      @clients = parse_clients(file_path)
    end

    def search(full_name:)
      clients.select do |client|
        client["full_name"].downcase.include?(full_name.downcase)
      end
    end

    def find_duplicates
      clients
        .group_by { |client| client["email"] }
        .select { |_email, group| group.size > 1 }
    end

    private

    def parse_clients(file_path)
      raise "File not exists" unless File.exist?(file_path)

      JSON.parse(File.read(file_path))
    end
  end
end
