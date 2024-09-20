# frozen_string_literal: true

require "spec_helper"
require "open3"

RSpec.describe "bin/clients_search" do
  let(:bin_path) { File.join(File.dirname(__FILE__), "..", "..", "bin", "clients_search") }
  let(:default_json_path) { File.join(File.dirname(__FILE__), "..", "..", "spec", "data", "clients.json") }
  let(:custom_json_path) { File.join(File.dirname(__FILE__), "..", "..", "spec", "data", "custom_clients.json") }

  before do
    # Ensure the custom JSON file exists with some test data
    File.write(custom_json_path, [
      {"id" => 1, "full_name" => "Test User", "email" => "test@example.com"},
      {"id" => 2, "full_name" => "Another User", "email" => "another@example.com"},
      {"id" => 3, "full_name" => "Test User", "email" => "test2@example.com"}
    ].to_json)
  end

  after do
    File.delete(custom_json_path) if File.exist?(custom_json_path)
  end

  def run_command(*args)
    Open3.capture3("ruby", bin_path, *args)
  end

  describe "search command" do
    it "searches by name using the default JSON file" do
      stdout, _stderr, status = run_command("search", "full_name", "John")
      expect(status.success?).to be true
      expect(stdout).to include("John")
        .and include("Alex Johnson")
    end

    it "searches by name using a custom JSON file" do
      stdout, _stderr, status = run_command("search", "full_name", "Test", custom_json_path)
      expect(status.success?).to be true
      expect(stdout).to include("Test User")
      expect(stdout).not_to include("Another User")
    end

    it "handles no results" do
      stdout, _stderr, status = run_command("search", "full_name", "Nonexistent")
      expect(status.success?).to be true
      expect(stdout).to include("No clients match for Nonexistent on full_name")
    end
  end

  describe "find_duplicates command" do
    it "finds duplicate names using the default JSON file" do
      _stdout, _stderr, status = run_command("find_duplicates")
      expect(status.success?).to be true
    end

    it "finds duplicate names using a custom JSON file" do
      stdout, _stderr, status = run_command("find_duplicates", "full_name", custom_json_path)
      expect(status.success?).to be true
      expect(stdout).to include("Test User")
      expect(stdout).not_to include("Another User")
    end

    it "finds duplicate emails using a custom JSON file" do
      stdout, _stderr, status = run_command("find_duplicates", "email", custom_json_path)
      expect(status.success?).to be true
      expect(stdout).to include("No duplicate clients on email")
    end
  end

  describe "error handling" do
    it "handles non-existent JSON files" do
      stdout, _stderr, status = run_command("search", "full_name", "John", "nonexistent.json")
      expect(status.success?).to be false
      expect(stdout).to include("JSON file not found!")
    end
  end
end
