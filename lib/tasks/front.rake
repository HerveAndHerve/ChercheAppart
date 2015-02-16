namespace :front do

  desc "test front application"
  task :test do 
    Dir.chdir('FrontApp') do
      puts "pending"
      sh "pwd"
      sh "npm install"
      sh "bower install"
      sh "gulp test"
    end
  end

  desc "build front application"
  task :build do 
    Dir.chdir('FrontApp') do
      puts "pending"
      sh "pwd"
      sh "npm install"
      sh "bower install"
      sh "gulp compile"
      sh "rsync -Pa bin/ ../public/"
      sh "chmod go+rx public/ -R"
    end
  end

end
