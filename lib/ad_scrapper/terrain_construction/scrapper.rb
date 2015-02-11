module AdScrapper
  module TerrainConstruction
    class Scrapper < AdScrapper::Scrapper

      attr_accessor :pages

      def initialize(params)

        @pages = Hash.new do |h,k|
          h[k] = get_page(k)
        end

        super
      end

      def get_page(i)
        Page.new(
          "http://www.terrain-construction.com/search/terrain-a-vendre/Paris-75000/75-Paris?page=#{i}&rayon=#{max_dist_from_paris}&terrain=1%252C0&ordre=prix&superficie=#{min_surface}"
        )
      end

      def number_of_pages
        @nb ||= (
          nb = pages[0].content.xpath("//li[contains(@class,'pager-last')]//a").first.attributes["href"].to_s.scan(/page=([0-9]+)/).first.first.to_i
          puts "[terrain-construction] found #{nb} pages of results"
          nb
        )
      end

      def all_pages
        (0..number_of_pages).lazy.map do |i|
          pages[i]
        end
      end

    end
  end
end
