namespace :ads do

  #desc "get terrain-construction lands"
  #task terrain_construction: :environment do 
  #  puts "min_surf=#{@min_surf}"
  #  #terrain-construction
  #  puts "fetching lands from terrain-construction.com"
  #  tc = LandsScrapper::TerrainConstruction::Scrapper.new(min_surface: @min_surf, max_dist_from_paris: 900).delayed_saved_new_lands!

  #end

  desc "check if the urls are still active"
  task check_urls: :environment do
    Ad.each do |ad|
      ad.delay.check_url!
    end
  end

  desc "get seloger.com ads"
  task seloger: :environment do 
    puts "fetching ads from seloger.com"
    sl = AdScrapper::SeLoger::Scrapper.new.delayed_save_new_ads!
  end

  desc "scrap the ouèbe to find new ads"
  task update: [:environment,:seloger]

end
