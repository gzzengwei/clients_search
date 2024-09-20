# frozen_string_literal: true

RSpec.describe ClientsSearch::Repository do
  let(:file_path) { "spec/data/clients.json" }

  let(:clients) do
    [
      {
        "id" => 1,
        "email" => "john.doe@gmail.com",
        "full_name" => "John Doe"
      },
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
    ]
  end

  let(:repository) { described_class.new(clients: clients) }

  context "#search" do
    it "returns matched clients by field" do
      expect(repository.search(field: "full_name", query: "john")).to include(
        {
          "id" => 1,
          "email" => "john.doe@gmail.com",
          "full_name" => "John Doe"
        }
      )
    end
  end

  context "#find_duplicates" do
    it "returns duplicated email clients" do
      expect(repository.find_duplicates).to include(
        "jane.smith@yahoo.com" => [
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
        ]
      )
    end
  end
end
