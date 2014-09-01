module GitDuplicator
  # Mirror a repository and end make it ready for updates
  class UpdateDuplicator < Duplicator
    protected
    
    def perform_clone_source
      from.mirror_clone(clone_path)
    end

    def perform_mirror
      from.set_mirrored_remote(to.url)
      from.update_mirrored
    end

    def perform_clean_up; end
  end
end
