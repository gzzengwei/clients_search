# frozen_string_literal: true

module ClientsSearch
  class Cache
    def initialize
      @cache = {}
    end

    def get(key)
      @cache[key]
    end

    def set(key, value)
      @cache[key] = value
    end
  end
end
