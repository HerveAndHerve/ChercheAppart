module AdScrapper
  module TerrainConstruction
    class Page < AdScrapper::Page

      def lands_hash
        content.xpath("//div[contains(@class,'node-annonce')]").map do |raw_land|
          h = {
            provider: :terrain_construction,
            price_in_euro: (raw_land.xpath(".//div[contains(@class,'group-left')]//span[contains(@class,'prix')]").first.text.gsub(" ","_").to_i rescue nil),
            locality: (raw_land.xpath(".//span[contains(@class,'locality')]").first.text rescue nil),
            postal_code: (raw_land.xpath(".//span[contains(@class,'postal-code')]").first.text.to_i rescue nil),
            department: (raw_land.xpath(".//span[contains(@class,'postal-code')]").first.text.to_i / 1000 rescue nil),
            surface_in_squared_meters: (raw_land.xpath(".//span[contains(@class,'superficie')]").first.text.gsub(" ",'').scan(/([0-9]+)/).first.first.to_i rescue nil),
            description: (raw_land.xpath(".//h3[contains(@class,'plus')]").first.text rescue nil),
            url: ("http://www.terrain-construction.com" << raw_land.xpath(".//div[contains(@class,'group-footer')]//a").first.attributes["href"].value rescue nil),
            img: ( raw_land.xpath(".//div[contains(@class,'result-photo')]//img").first.attributes["src"].value rescue nil),
          }

          h.merge({
            town_id: (Town.where_autocomplete(h[:locality]).find_by(department: h[:department]).id rescue nil)
          })

        end
      end

    end
  end
end
