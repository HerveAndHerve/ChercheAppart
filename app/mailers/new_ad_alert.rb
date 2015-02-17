class NewAdAlert < ActionMailer::Base
  default from: "info@#{ENV['DOMAIN']}"

  def notify(user,project,ad)
    @username = user.first_name
    @project_name = project.name
    @link_url = 'http://' + ENV['DOMAIN'] + "#/project/#{project.id}/news"
    mail(to: user.email, subject: "[CHERCHEAPPART] nouvelle annonce disponible")
  end
end
