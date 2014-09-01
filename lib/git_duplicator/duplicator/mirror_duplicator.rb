module GitDuplicator
  # Mirror a repository
  class MirrorDuplicator < Duplicator
    protected

    def perform_clone_source
      from.bare_clone(clone_path)
    end

    def perform_mirror
      from.mirror(to.url)
    end

    def perform_clean_up
      FileUtils.rm_rf("#{clone_path}/#{from.name}")
    end
  end
end
