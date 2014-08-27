module GitDuplicator
  # Abstract class to use when defining new Git service provider
  class ServiceRepository < Repository
    attr_accessor :owner

    # Initializer
    # @param [String] name name of the repository
    # @param [String] owner owner of the repository
    def initialize(name, owner)
      self.owner = owner
      super(name, url)
    end

    # URL of the repositroy
    def url
      fail NotImplementedError
    end

    # Create the repositroy
    def create
      fail NotImplementedError
    end

    # Delete the repositroy
    def delete
      fail NotImplementedError
    end
  end
end
