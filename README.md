#Ruby assessment

This is basically a service module to connect a rails application with Mailgun.It was an accessment for a job and it was developed in a few hours so it is just a sample of my work. Also I can't review publicly what were the assessment specifications so if you find some strange/unusual/funny log or functionality it may be due that. 

The module is under `app/services/mailgun.rb`, the tests are in `test/services/mailgun_test.rb`, the endpoint for setting the webhooks is `/api/mailgun`. 

It requires the following environment variables to be exported:

```
ENV['MAILGUN_KEY']
ENV['MAILGUN_DOMAIN'] 
ENV['MAILGUN_DEFAULT_SENDER'] 
```
tests can be run with this command: `rake test`
