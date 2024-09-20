# frozen_string_literal: true

RSpec.describe ClientsSearch::CLI do
  let(:file_path) { "spec/data/clients.json" }
  let(:cli) { described_class.new(file_path: file_path) }

  context "wrong file path" do
    let(:file_path) { "spec/data/not_exists.json" }

    it "raises exception" do
      expect { cli }.to raise_error("File not exists")
    end
  end

  context "#search" do
    it "returns matched clients" do
      expect(cli.search(full_name: "Jane")).to include(
        {
          "id" => 2,
          "email" => "jane.smith@yahoo.com",
          "full_name" => "Jane Smith"
        },
        {
          "id" => 15,
          "email" => "jane.smith@yahoo.com",
          "full_name" => "Another Jane Smith"
        }
      )
    end
  end
end
