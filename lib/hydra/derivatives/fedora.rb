# frozen_string_literal: true
begin
  require 'active_fedora'
rescue LoadError
end

# frozen_string_literal: true
module Hydra::Derivatives
  module Fedora
    extend ActiveSupport::Autoload

    autoload :TempfileService
    autoload :PersistBasicContainedOutputFileService
    autoload :PersistExternalFileOutputFileService
  end
end
