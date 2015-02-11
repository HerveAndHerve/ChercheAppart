require 'open-uri'
require 'nokogiri'
module AdScrapper

  #abstract class
  class Scrapper
    attr_accessor :min_surface, :max_dist_from_paris

    def initialize(params)
    end

    def delayed_save_new_ads!
      all_pages.each do |p|
        p.delay.save_new_ads!
      end
    end

  end
end
