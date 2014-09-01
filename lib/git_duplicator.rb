require_relative 'git_duplicator/version'
require_relative 'git_duplicator/duplicators'
require_relative 'git_duplicator/repositories'
require_relative 'git_duplicator/services'

# Main module
module GitDuplicator
  class << self
    # Perform the duplication
    # @see GitDuplicator::MirrorDuplicator
    def perform(from, to, options)
      MirrorDuplicator.new(from, to, options).perform
    end

    # Perform the duplication for updates
    # @see GitDuplicator::UpdateDuplicator
    def perform_for_update(from, to, options)
      UpdateDuplicator.new(from, to, options).perform
    end
  end
end
