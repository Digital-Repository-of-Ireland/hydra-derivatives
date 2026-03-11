# frozen_string_literal: true
require 'mime/types'

module Hydra::Derivatives
  class TempfileService
    def self.create(file, &block)
      new(file).tempfile(&block)
    end

    attr_reader :source_file

    def initialize(source_file)
      @source_file = source_file
    end

    def tempfile(&block)
      if source_file.respond_to? :to_tempfile
        source_file.send(:to_tempfile, &block)
      else
        default_tempfile(&block)
      end
    end

    def default_tempfile(&_block)
      Tempfile.open(filename_for_characterization) do |f|
        f.binmode
        f.write(source_file.read)

        source_file.rewind if source_file.respond_to? :rewind
        f.rewind
        yield(f)
      end
    end

    def filename_for_characterization
      version_id = 1 # TODO: fixme
      filename = File.basename(source_file.path, ".*")
      extension = File.extname(source_file.path)
      ["#{filename}-#{version_id}", extension.to_s]
    end
  end
end
