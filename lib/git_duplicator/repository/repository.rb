require 'git'

module GitDuplicator
  # Basic Repostiroy
  class Repository
    attr_accessor :name, :url
    attr_reader :working_directory

    # Initializer
    # @param [String] name name of the repository
    # @param [String] url URL of the repository
    # @param [String] working_directory working directory of the repository
    def initialize(name, url, working_directory = nil)
      self.name = name
      self.url = url
      self.working_directory = working_directory
    end

    def working_directory=(value)
      @working_directory = value
      @repo = repo_from_path
    end

    # Bare clone the repository
    # @param [String] path_to_repo path to clone the repository to
    def bare_clone(path_to_repo)
      self.repo = Git.clone(url, name, bare: true, path: path_to_repo)
    rescue => exception
      raise RepositoryCloningError, exception.message
    end

    # Mirror clone the repository
    # @param [String] path_to_repo path to clone the repository to
    def mirror_clone(path_to_repo)
      path = File.join(path_to_repo, name)
      command('clone', '--mirror', url, path)
      self.repo = Git.bare(path)
    rescue => exception
      raise RepositoryCloningError, exception.message
    end

    # Mirror the repository
    # @param [String] mirrored_url URL of mirrored repository
    def mirror(mirrored_url)
      fail('No local repo defined. Set the "repo" attribute') unless repo
      repo.push(mirrored_url, '--mirror')
    rescue => exception
      raise RepositoryMirorringError, exception.message
    end

    # Set the remote URL of the mirrored
    # @param [String] mirrored_url URL of mirrored repository
    def set_mirrored_remote(mirrored_url)
      fail('No local repo defined. Set the "repo" attribute') unless repo
      command('remote', 'set-url', '--push', 'origin', mirrored_url)
    rescue => exception
      raise RepositorySettingRemoteError, exception.message
    end

    # Update a mirrored repository
    def update_mirrored
      fail('No local repo defined. Set the "repo" attribute') unless repo
      command('fetch', '-p', 'origin')
      command('push', '--mirror')
    rescue => exception
      raise RepositoryMirorredUpdatingError, exception.message
    end

    protected

    attr_reader :repo # for testing

    def repo=(value)
      @repo = value
      @working_directory = working_directory_from_repo
    end

    def repo_from_path
      if working_directory
        Git.open(working_directory) rescue Git.bare(working_directory)
      else
        nil
      end
    end

    def working_directory_from_repo
      return nil if repo.nil?
      if repo.dir
        repo.dir.path
      elsif repo.repo
        repo.repo.path
      else
        nil
      end
    end

    def command(cmd, *opts)
      git_cmd = "git #{cmd} #{opts.join(' ')}"
      out = run_command(git_cmd)
      if $?.exitstatus > 0
        if $?.exitstatus == 1 && out == ''
          return ''
        end
        fail(git_cmd + ': ' + out.to_s)
      end
    end

    def run_command(cmd)
      exec = "#{cmd} 2>&1"
      if working_directory
        Dir.chdir(working_directory) { `#{exec}` }
      else
        `#{exec}`
      end.chomp
    end
  end
end
