class NewAdAlert < ActionMailer::Base
  default from: "do_not_reply@chercheappart.fr"

  def notify(user,project,ad)
    @username = user.first_name
    @project_name = project.name
    @link_url = ENV['DOMAIN'] + "#/project/#{project.id}/news"
    mail(to: user.email, subject: "[CHERCHEAPPART] nouvelle annonce disponible")
  end
end
