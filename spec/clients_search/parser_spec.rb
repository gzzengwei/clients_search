# frozen_string_literal: true

RSpec.describe ClientsSearch::Parser do
  describe ".call" do
    subject { described_class.call(file_path: file_path) }

    context "for valid json file" do
      let(:file_path) { "spec/data/clients_test.json" }

      it "returns parsed json" do
        expect(subject).to eq([
          {
            "id" => 1,
            "email" => "john.doe@gmail.com",
            "full_name" => "John Doe"
          },
          {
            "id" => 2,
            "email" => "jane.smith@yahoo.com",
            "full_name" => "Jane Smith"
          }
        ])
      end
    end

    context "for file not exists" do
      let(:file_path) { "spec/data/not_exists.json" }

      it "raises 'JSON file not found!' exception" do
        expect { subject }.to raise_error("JSON file not found!")
      end
    end

    context "for invalid json file" do
      let(:file_path) { "spec/data/invalid.json" }

      it "raises 'JSON file not valid!' exception" do
        expect { subject }.to raise_error("JSON file not valid!")
      end
    end
  end
end
