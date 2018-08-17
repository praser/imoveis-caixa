require 'ruby-progressbar'
require_relative 'utils/download_realty_table'
require_relative 'utils/uncompress'
require_relative 'utils/file_manager'
require_relative 'utils/progress'

# Download all estates offers data
class DownloadFiles
  attr_accessor :folder
  ESTATES = %w[
    AC AL AP AM BA CE DF ES GO MA MT MS MG PA PB PR PE PI RJ RN RS RO RR SC SP
    SE TO
  ].freeze

  def initialize(folder = nil)
    @folder = folder || File.join(__dir__, '..', 'temp')
    @progress = Utils::Progress.new(ESTATES.size, 'Downloading')
  end

  def empty
    Utils::FileManager.new(@folder).clear_folder
  end

  def download
    ESTATES.each do |uf|
      Utils::DownloadRealtyTable.new(uf, @folder).start
      @progress.bar.increment
    end
  end

  def uncompress
    Utils::Uncompress.extract_all(@folder)
  end
end
