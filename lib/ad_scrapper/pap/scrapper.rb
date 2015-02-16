module AdScrapper
  module Pap
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
        AdScrapper::Pap::Page.new(
          "http://www.pap.fr/annonce/locations-appartement-#{district_code(district)}-#{i}",
          district
        )
      end

      def number_of_pages(district)
        @nb_of_pages ||= Hash.new do |h,district|
          h[district] = (
            nb_annonces = @pages[district][1].content.xpath(".//div[contains(@class,'nombre-annonce')]").text.match(/(\d.+)/)[1].to_i
            nb_par_page = @pages[district][1].content.xpath(".//select[contains(@id,'nb_resultats_par_page')]/option[contains(@selected,'selected')]").text.strip.chomp.match(/(\d.+)/)[1].to_i
            return 0 if nb_annonces <= 0 or nb_par_page == 0
            nb = (nb_annonces / nb_par_page ).ceil
            puts "[pap.fr]: found #{nb} pages of results in district #{district}" 
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

      protected 

      def district_code(district)
        h = {
          '75001' => 'paris-1er-g37768',
          '75002' => 'paris-2e-g37769',
          '75003' => 'paris-3e-g37770',
          '75004' => 'paris-4e-g37771',
          '75005' => 'paris-4e-g37772',
          '75006' => 'paris-4e-g37773',
          '75007' => 'paris-4e-g37774',
          '75008' => 'paris-4e-g37775',
          '75009' => 'paris-4e-g37776',
          '75010' => 'paris-4e-g37777',
          '75011' => 'paris-4e-g37778',
          '75012' => 'paris-4e-g37779',
          '75013' => 'paris-4e-g37780',
          '75014' => 'paris-4e-g37781',
          '75015' => 'paris-4e-g37782',
          '75016' => 'paris-4e-g37783',
          '75017' => 'paris-4e-g37784',
          '75018' => 'paris-4e-g37785',
          '75019' => 'paris-4e-g37786',
          '75020' => 'paris-4e-g37787',
        }
        h[district.to_s]
      end

    end
  end
end
