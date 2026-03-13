# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Hydra::Derivatives::LocalFileService do
  describe ".call" do
    let(:file_name) { 'spec/fixtures/piano_note.wav' }

    it "yields the file name given" do
      expect do |blk|
          described_class.call(file_name, {}, &blk)
        end.to yield_with_args do |file|
          expect(file.path).to eq file_name
        end
    end
  end
end