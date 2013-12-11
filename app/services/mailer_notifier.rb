class MailerNotifier
  attr_reader :mailer_klass, :mail_method

  NoMail = Class.new(StandardError)

  def initialize(mailer_klass, mail_method)
    @mailer_klass = mailer_klass
    @mail_method = mail_method
  end

  def notify(*args)
    if mailer_klass.respond_to?(mail_method)
      mail = mailer_klass.send(mail_method, *args)
      mail.deliver
      mail
    else
      raise NoMail.new("no email found for '#{mailer_klass}##{mail_method}'")
    end
  end
end
