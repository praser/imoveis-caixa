module Utils
  # The cool Progressbar
  class Progress
    attr_accessor :bar
    CONFIG = {
      format: '%t: %a %e |%b>>%i| %p%% - %c from %C',
      starting_at: 0
    }.freeze

    def initialize(total, title)
      @bar = ProgressBar.create(CONFIG.merge(total: total, title: title))
    end
  end
end
