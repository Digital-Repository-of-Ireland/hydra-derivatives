# frozen_string_literal: true
RSpec.describe Hydra::Derivatives::PersistDerivatives do
  describe '.output_file' do
    subject { described_class.output_file(directives, &block) }

    let(:directives) { { url: "file:/tmp/12/34/56/7-thumbnail.jpeg" } }
    let(:destination_name) { 'thumbnail' }

    let(:block) { -> { true } }

    it 'yields to the file' do
      expect(FileUtils).to receive(:mkdir_p).with('/tmp/12/34/56')
      expect(File).to receive(:open).with('/tmp/12/34/56/7-thumbnail.jpeg', 'wb') do |*_, &blk|
        expect(blk).to be(block)
      end
      subject
    end
  end

  describe '.call' do
    let(:stream) { 'spec/fixtures/piano_note.wav' }
    it 'copies the stream' do
      Tempfile.create do |tempfile|
        expect(IO).to receive(:copy_stream) do |source, file|
          expect(source.path).to eq stream
          expect(file.path).to eq tempfile.path
        end
        described_class.call(File.open(stream), { url: "file://#{tempfile.path}" })
      end
    end
  end
end