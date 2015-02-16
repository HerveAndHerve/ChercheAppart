module AdScrapper
  module Pap
    class Page < AdScrapper::Page

      # extract ads from page
      def ads_hash
        @ads_hash ||= content.xpath(".//li[contains(@class,'annonce')]").map do |p|
          h = {
            provider: :pap,
            price:       (p.xpath(".//span[contains(@class,'prix')]").first.text.gsub(/\D/,'').to_i rescue nil),
            location:    nil,
            surface:     (p.xpath(".//span[contains(@class,'surface')]/..").children[2].text.strip.to_i rescue nil),
            description: (p.xpath(".//div[contains(@class,'description')]/p").first.text.strip rescue nil),
            url:         ((relative = p.xpath(".//a").first.attributes["href"].value rescue nil).blank? ? nil : relative.prepend("http://pap.fr")),
            img:         (p.xpath(".//img").first.attributes["src"].value rescue nil),
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
