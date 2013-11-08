class UserNotifier < ActionMailer::Base
  
  default content_type: 'text/html'

  def reset_notification(user)
    @user = user
    @url = "#{SITE_URL}/reset/#{user.reset_code}"
    mail(:subject => 'OligoMgmt: Link to reset your password',
	     :from => EMAIL_FROM,
		   :to => user.email)
  end
end
