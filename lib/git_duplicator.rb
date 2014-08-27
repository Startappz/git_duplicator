require_relative 'git_duplicator/version'
require_relative 'git_duplicator/duplicator'
require_relative 'git_duplicator/repositories'
require_relative 'git_duplicator/services'

# Main module
module GitDuplicator
  class << self
    # Perform the duplication
    # @see GitDuplicator::Duplicator
    def perform(from, to, options)
      Duplicator.new(from, to, options).perform
    end
  end
end
