class NewAdAlert < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.new_ad_alert.notify.subject
  #
  def notify(user,project,ad)
    @username = user.first_name
    @project_name = project.name
    @link_url = ENV['DOMAIN'] + "#/project/#{project.id}/news"
    mail(to: user.email)
  end
end
