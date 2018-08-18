require 'nokogiri'
require 'logger'
require_relative 'utils/file_manager'
require_relative 'utils/output'
require_relative 'realty/parser'

# Parse file into Ralty instance
class ParseFiles
  attr_accessor :realties

  def initialize(output = nil, log = nil, temp = nil)
    @temp = temp || File.join(__dir__, '..', 'temp')
    @log = log || File.join(__dir__, '..', 'logs')
    @output = output

    @timestamp = Time.now.strftime('%Y%m%d%H%M%S')
    @nodes = []
    @progress = Utils::Progress.new(size, 'Processing')
    @realties = { realties: [] }
    logfile = File.join(@log, "#{@timestamp}.log")
    @logger = Logger.new(logfile)
  end

  def empty
    Utils::FileManager.new(@temp).clear_folder
  end

  def parse
    @nodes.each do |node|
      node.each do |realty|
        parse_node(realty)
      end
    end
  end

  def to_file
    Utils::Output.new(@output).to_json_file @timestamp, @realties
  end

  private

  def nodes
    return @nodes unless @nodes.empty?

    files = Dir.glob(File.join(@temp, '*.htm'))
    files.each do |html|
      doc = Nokogiri::HTML(File.open(html))
      @nodes.push doc.css('html > body > table > tr:nth-child(n+2)')
    end
  end

  def size
    nodes if @nodes.empty?
    @nodes.map(&:size).inject(:+)
  end

  def parse_node(realty)
    parser = Realty::Parser.new(@temp)
    begin
      parser.main_data(realty)
      parser.additional_data
      @realties[:realties].push parser.realty.to_hash
    rescue StandardError => error
      @logger.error "#{parser.realty.url}: #{error.message}"
      @logger.error error.backtrace
    end
    @progress.bar.increment
  end
end
