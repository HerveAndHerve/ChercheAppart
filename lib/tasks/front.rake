namespace :front do

  desc "test front application"
  task :test do 
    Dir.chdir('FrontApp') do
      sh "pwd"
      sh "npm install"
      sh "bower install"
      sh "gulp test"
    end
  end

  desc "build front application"
  task :build do 
    Dir.chdir('FrontApp') do
      sh "pwd"
      sh "npm install"
      sh "bower install"
      sh "gulp compile"
      sh "rsync -Pa bin/ ../public/"
      sh "chmod go+rx ../public/ -R"
    end
  end

  desc "setup front tools"
  task :setup do
    Dir.chdir('FrontApp') do
      sh "npm install -g bower"
      sh "npm install -g karma"
      sh "npm install -g gulp-cli"
    end
  end

end
