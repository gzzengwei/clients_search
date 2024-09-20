# frozen_string_literal: true

require "json"

module ClientsSearch
  class Repository
    DEFAULT_DUPLICATES_FIELD = "email"

    attr_reader :clients

    def initialize(clients:)
      @clients = clients
    end

    def search(field:, query:)
      clients.select do |client|
        client[field].to_s.downcase.include?(query.downcase)
      end
    end

    def find_duplicates(field:)
      field ||= DEFAULT_DUPLICATES_FIELD

      clients
        .group_by { |client| client[field] }
        .select { |_field, group| group.size > 1 }
    end
  end
end
