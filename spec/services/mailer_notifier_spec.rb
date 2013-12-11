require_relative "../../app/services/mailer_notifier"

describe MailerNotifier do
  let(:deliverable_object) { double(:deliverable_object, :deliver => true) }

  describe "#notify" do
    it "executes delivery of passed email with passed arguments through notify" do
      mailer_klass = double(:UserMailer)
      mailer_klass.should_receive(:hello_message).with(1, "2", [3], :arguments => nil).and_return(deliverable_object)

      notifier = MailerNotifier.new(mailer_klass, :hello_message)
      notifier.notify(1, "2", [3], :arguments => nil)
    end

    it "raises NoEmail exception when given object does not respond to expected mailer method" do
      mailer_klass = double(:UserMailer)

      notifier = MailerNotifier.new(mailer_klass, :bad_message)
      expect{ notifier.notify }.to raise_error(MailerNotifier::NoMail)
    end
  end
end