require 'open-uri'
require 'nokogiri'
module AdScrapper
  #Abstract class
  class Page

    attr_reader :url
    attr_reader :district
    def initialize(url,district)
      @url = url
      @district = district
    end

    def content
      @content ||= Nokogiri::HTML(open(url), nil, "UTF-8")
    end

    # specific to each provider
    def ads_hash
      []
    end

    def ads
      @ads ||= ads_hash.map do |h| 
        Ad.new(
          h.slice(
            :name,
            :url,
            :provider,
            :surface,
            :price,
            :description,
            :location,
            :img,
          ).merge(district: @district)
        )
      end
    end

    def new_ads
      ads.reject{|h| Ad.where(url: h[:url]).exists?}
    end

    def save_new_ads!
      new_ads.map(&:save).reduce(:&)
    end

  end
end
