module GitDuplicator
  class MigrationError < StandardError; end

  class RepositoryDeletionError < MigrationError; end

  class RepositoryCreationError < MigrationError; end

  class RepositoryCloningError < MigrationError; end

  class RepositoryMirorringError < MigrationError; end
end
