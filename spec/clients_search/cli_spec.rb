# frozen_string_literal: true

RSpec.describe ClientsSearch::CLI do
  let(:repository) { ClientsSearch::Repository.new(clients: clients) }
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
  let(:cli) { described_class.new(repository: repository) }

  describe "#run" do
    context "for search command" do
      it "outputs matched clients" do
        expect { cli.call(["search", "John"]) }.to output(
          include("Matched clients for John")
          .and(include("john.doe@gmail.com"))
        ).to_stdout
      end

      it "outputs for no matched clients" do
        expect { cli.call(["search", "Whoever"]) }.to output(
          include("No clients match for Whoever")
        ).to_stdout
      end
    end

    context "#find_duplicates" do
      it "outputs duplicated email clients" do
        expect { cli.call(["find_duplicates"]) }.to output(
          include("Duplicate clients:")
          .and(include("for jane.smith@yahoo.com:")
          .and(include("Jane Smith")
          .and(include("Another Jane Smith"))))
        ).to_stdout
      end
    end
  end
end
