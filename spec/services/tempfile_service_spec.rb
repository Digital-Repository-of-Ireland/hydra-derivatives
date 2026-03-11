# frozen_string_literal: true
require 'spec_helper'

describe Hydra::Derivatives::TempfileService do
  subject { described_class.new(file) }

  let(:class_with_tempfile) do
    Class.new do
      def to_tempfile
        "stub"
      end
    end
  end

  let(:class_with_content) do
    Class.new do
      def read
        "test"
      end

      def path
        "/file/test.png"
      end
    end
  end

  let(:file) { File.open(File.expand_path('../../fixtures/world.png', __FILE__)) }

  describe '#tempfile' do
    it 'has a method called to_tempfile' do
      expect { |b| subject.tempfile(&b) }.to yield_with_args(Tempfile)
    end
    it "will call read on passed content if available" do
      service = described_class.new(class_with_content.new)

      service.tempfile do |t|
        expect(t.read).to eq "test"
      end
    end
    it "delegates down to `to_tempfile` if available" do
      tempfile_stub = class_with_tempfile.new
      service = described_class.new(tempfile_stub)

      expect(service.tempfile).to eq "stub"
    end
  end
end
