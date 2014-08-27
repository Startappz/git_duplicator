require 'git'

module GitDuplicator
  # Basic Repostiroy
  class Repository
    attr_accessor :name, :url
    attr_reader :repo

    # Initializer
    # @param [String] name name of the repository
    # @param [String] url URL of the repository
    def initialize(name, url)
      self.name = name
      self.url = url
    end

    # Repository attribute setter
    # @param [Git::Base] repository
    def repo=(repository)
      fail(TypeError) unless repository.is_a?(Git::Base)
      @repo = repository
    end

    # Bare clone the repository
    # @param [String] path_to_repo path to clone the repository to
    def bare_clone(path_to_repo)
      self.repo = Git.clone(url, name, bare: true, path: path_to_repo)
    rescue => exception
      raise RepositoryCloningError, exception.message
    end

    # Mirror the repository
    # @param [String] destination_url URL of destination repository 
    def mirror(destination_url)
      fail('No local repo defined. Set the "repo" attribute') unless repo
      repo.push(destination_url, '--mirror')
    rescue => exception
      raise RepositoryMirorringError, exception.message
    end
  end
end
