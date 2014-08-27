require 'fileutils'
require_relative 'null_logger'

module GitDuplicator
  class Duplicator
    attr_accessor :from, :to, :logger, :clone_path, :force_create_destination

    # @param [GitDuplicator::Repository, GitDuplicator::ServiceRepository]
    #  from repository to mirror
    # @param [GitDuplicator::Repository, GitDuplicator::ServiceRepository]
    #  to repository to mirror to
    # @param [Hash] options
    # @option options [String] :clone_path
    #   path to clone the repository to
    # @option options [Boolean] :force_create_destination
    #  delete the exisiting service repo then create it
    # @option options [#info] :logger log what's going on
    def initialize(from, to, options = {})
      self.from = from
      self.to = to
      self.clone_path = options.fetch(:clone_path) { '/tmp' }
      self.force_create_destination =
        options.fetch(:force_create_destination) { false }
      self.logger = options.fetch(:logger) { NullLogger.new }
    end

    # Perform the duplication
    def perform
      recreate_destination
      clone_source
      mirror
    ensure
      clean_up
    end

    private

    attr_accessor :source_cloned

    def recreate_destination
      return unless force_create_destination
      logger.info("Deleting existing destination repo: #{to.url}")
      to.delete
      logger.info("Creating destination repo: #{to.url}")
      to.create
    end

    def clone_source
      logger.info("Cloning bare Gitorious repo: #{from.url}")
      from.bare_clone(clone_path)
      self.source_cloned = true
    end

    def mirror
      logger.info("Mirroring Gitorious to Bitbucket: #{from.url}")
      from.mirror(to.url)
    end

    def clean_up
      return unless source_cloned
      logger.info 'Clean local source repo'
      FileUtils.rm_rf("#{clone_path}/#{from.name}")
      @cloned = nil
    end
  end
end
