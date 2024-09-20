# frozen_string_literal: true

require "json"

module ClientsSearch
  class Repository
    attr_reader :clients

    def initialize(clients:)
      @clients = clients
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
  end
end
