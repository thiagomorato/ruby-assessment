require 'test_helper'

class MailgunTest < ActionController::TestCase

  test 'should should check if send sends the right request' do

    endpoint = "https://api.mailgun.net/v3/#{ENV['MAILGUN_DOMAIN']}/messages"

    data = {
      "from"=>"noreply@testing.com",
      "o:campaign"=>"2",
      "subject"=>"subject",
      "text"=>"text text text",
      "to"=>"test@testing.com"
    }

    response = '{ "id": "12341234", "message": "Queued. Thank you."}'

    # if returns 200 it was sent sucessfully
    stub_request(:post, endpoint)
      .with(:body => data)
      .to_return(:status => 200, :body => response)

    result = Mailgun.send data['to'], data['subject'], data['text'], data['o:campaign']

    assert_equal JSON.parse(response), result

    # if returns 400 there was issue in the request body
    stub_request(:post, endpoint)
      .with(:body => data)
      .to_return(:status => 400)

    Mailgun.expects(:handle_errors).once()

    assert_not Mailgun.send data['to'], data['subject'], data['text'], data['o:campaign']
  end

  test 'should check if resourse_exists? function return the correct value' do

    email = 'test@testing.com';
    endpoint = "https://api.mailgun.net/v3/#{ENV['MAILGUN_DOMAIN']}/bounces/"+email

    # if returns 200 it is bounced
    stub_request(:get, endpoint)
      .to_return(:status => 200)

    assert Mailgun.resourse_exists? "/bounces/"+email

    #if return 404 is is not bounced
    stub_request(:get, endpoint)
      .to_return(:status => 404)

    assert_not Mailgun.resourse_exists? "/bounces/"+email

    #if return 400 there is an error on your request
    stub_request(:get, endpoint)
      .to_return(:status => 400)

    Mailgun.expects(:handle_errors).once()

    assert_nil Mailgun.resourse_exists? "/bounces/"+email


  end

  test 'should check if is_bounced? calls resourse_exists?' do
    email = 'test@testing.com';

    Mailgun.expects(:resourse_exists?)
      .with("/bounces/"+email)
      .once()
      .returns(false)

    assert_not Mailgun.is_bounced? email
  end

  test 'should check if is_unsubscribed? calls resourse_exists?' do
    email = 'test@testing.com';

    Mailgun.expects(:resourse_exists?)
      .with("/unsubscribes/"+email)
      .once()
      .returns(false)

    assert_not Mailgun.is_unsubscribed? email
  end

  test 'should check if is_complained? calls resourse_exists?' do
    email = 'test@testing.com';

    Mailgun.expects(:resourse_exists?)
      .with("/complaints/"+email)
      .once()
      .returns(false)

    assert_not Mailgun.is_complained? email
  end

  test 'should check if is_suppressed? calls returns the right value' do
    email = 'test@testing.com';

    # should return false if all false
    Mailgun.expects(:is_bounced?)
      .with(email)
      .returns(false)

    Mailgun.expects(:is_unsubscribed?)
      .with(email)
      .returns(false)

    Mailgun.expects(:is_complained?)
      .with(email)
      .returns(false)

    assert_not Mailgun.is_suppressed? email

    # should return true if at least one true
    Mailgun.expects(:is_bounced?)
      .with(email)
      .returns(true)

    assert Mailgun.is_suppressed? email
  end

  test 'should should check if sent_to sends the right request' do
    email = "test@testing.com"
    endpoint = "https://api.mailgun.net/v3/#{ENV['MAILGUN_DOMAIN']}/events"
    query = "?event=delivered&recipient="+email
    response = '{ "items": [1,2,3], "paging": { "next": "a","last": "b"}}'

    # if returns 200 it was sent sucessfully
    stub_request(:get, endpoint+query)
      .to_return(:status => 200, :body => response)

    assert_equal JSON.parse(response), Mailgun.sent_to(email)

    #if returns 400 there was issue in the request body
    stub_request(:get, endpoint+query)
      .to_return(:status => 400)

    Mailgun.expects(:handle_errors).once()

    assert_not Mailgun.sent_to email
  end

end
