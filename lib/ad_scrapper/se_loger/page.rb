module AdScrapper
  module SeLoger
    class Page < AdScrapper::Page

      # extract ads from page
      def ads_hash
        @ads_hash ||= content.xpath(".//article[contains(@class,'listing')]").map do |p|
          h = {
            provider: :seloger,
            price: (p.xpath(".//a[contains(@class,'amount')]").first.text.gsub(/\D/,'').to_i rescue nil),
            location: (p.xpath(".//h2//span").text rescue nil),
            surface: (to_squared_meters(p.xpath(".//ul[contains(@class,'property_list')]//li").map(&:text).select{|s| s.match(/ha\z/) or URI.encode(s).match(/[0-9]+m/)}.first ) rescue nil),
            description: (p.xpath(".//p[contains(@class,'description')]").first.text.chomp.strip rescue nil),
            url: (p.xpath(".//h2//a").first.attributes["href"].value rescue nil),
            img: (p.xpath(".//div[contains(@class,'listing_photo_container')]//img").first.attributes["src"].value rescue nil),
          }
        end
      end

      private 

      def to_squared_meters(text)
        return nil if text.nil?
        if text.match(/ha\z/) #result in hectares
          (text.gsub(',','.').split(" ").first.to_f * 10_000).to_i
        else
          text.to_i
        end
      end

    end
  end
end
