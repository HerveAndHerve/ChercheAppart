module AdScrapper
  module SeLoger
    class Scrapper < AdScrapper::Scrapper

      attr_accessor :pages

      def initialize(params={})
        @pages = Hash.new do |h,district|
          h[district] = Hash.new do |hh,i|
            hh[i] = get_page(district,i)
          end
        end
        super
      end

      def get_page(district,i)
        AdScrapper::SeLoger::Page.new(
          "http://www.seloger.com/list.htm?cp=#{district}&idtt=1&idtypebien=1&LISTING-LISTpg=#{i}",
          district
        )
      end

      def number_of_pages(district)
        @nb_of_pages ||= Hash.new do |h,district|
          h[district] = (
            text = @pages[district][1].content.xpath(".//p[contains(@class,'pagination_result_number')]").text
            nb_annonces = text.split(" ").first.to_i
            nb = begin
                   i,j = nb_annonces_per_page = text.split(" ").last.scan(/([0-9]+)/).map(&:first).map(&:to_i)
                   nb_annonces_per_page = j - i + 1
                   (nb_annonces / nb_annonces_per_page.to_f).ceil
                 rescue
                   0
                 end
            puts "[seloger.com]: found #{nb} pages of results in district #{district}" 
            nb
          )
        end
        @nb_of_pages[district]
      end

      def all_pages
        (75001..75020).lazy.flat_map do |district|
          (1..number_of_pages(district)).lazy.map do |i|
            pages[district][i]
          end
        end
      end

    end
  end
end
