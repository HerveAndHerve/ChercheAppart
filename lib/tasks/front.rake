namespace :front do

  desc "test front application"
  task :test do 
    Dir.chdir('FrontApp') do
      puts "pending"
    end
  end

  desc "build front application"
  task :build do 
    Dir.chdir('FrontApp') do
      puts "pending"
      #sh "pwd"
      #sh "npm install"
      #sh "bower install"
      #sh "grunt"
      #sh "rsync -Pa bin/ ../public/"
    end
  end

end
