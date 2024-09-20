# frozen_string_literal: true

require "json"

module ClientsSearch
  class Parser
    def self.call(file_path:)
      raise "JSON file not found!" unless File.exist?(file_path)

      JSON.parse(File.read(file_path))
    rescue JSON::ParserError
      raise "JSON file not valid!"
    end
  end
end
