# Intis::Sdk

The Intis telecom gateway lets you send SMS messages worldwide via its API. This program sends HTTP(s) requests and receives information as a response in JSON and/or XML. The main functions of our API include:

* sending SMS messages (including scheduling options);
* receiving status reports about messages that have been sent previously;
* requesting lists of authorised sender names;
* requesting lists of incoming SMS messages;
* requesting current balance status;
* requesting lists of databases;
* requesting lists of numbers within particular contact list;
* searching for a particular number in a stop list;
* requesting lists of templates;
* adding new templates;
* requesting monthly statistics;
* making HLR request;
* receiving HLR request statistics;
* requesting an operator’s name by phone number;

To begin using our API please [apply](https://go.intistele.com/external/client/register/) for your account at our website where you can get your login and API key.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'intis-sdk'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install intis-sdk

## Usage

Class Intis::Sdk::Client - The main class for SMS sending and getting API information

There are three mandatory parameters that you have to provide the constructor in order to initialize. They are:

* login - user login
* api_key - user API key
* api_host - API address

```ruby
client = Intis::Sdk::Client.new(login: 'your_api_login', api_key: 'your_api_key', api_host: 'your_api_host')
```

This class includes the following methods:

Use the get_balance method to request your balance status

```ruby
balance = client.get_balance

amount = balance[:money]         # Getting amount of money
currency = balance[:currency]    # Getting name of currency
```

To get a list of all the contact databases you have use the function get_base

```ruby
bases = client.get_base

bases.each do |id, base|
  id                        # Getting list ID
  base[:name]               # Getting list name
  base[:count]              # Getting number of contacts in list
  base[:pages]              # Getting number of pages in list
  
  base[:on_birth]           # Getting key that is responsible for sending greetings, 0 - do not send, 1 - send
  base[:day_before]         # Getting the number of days to send greetings before
  base[:birth_sender]       # Getting name of sender for greeting SMS
  base[:birth_text]         # Getting text template that will be used in the messages
  base[:time_birth]         # Getting time for sending greetings. All SMS will be sent at this time.
  base[:local_time]         # Getting variable that indicates using of local time while SMS sending.
end
```

Our gateway supports the option of having unlimited sender’s names. To see a list of all senders’ names use the method get_senders

```ruby
senders = client.get_senders

senders.each do |sender, status|
  sender                    # Getting sender name
  status                    # Getting sender status
end
```

To get a list of phone numbers from a certain contact list you need the get_phone(base_id, page) method. For your convenience, the entire list is split into separate pages. The parameters are: base_id - the ID of a particular database (mandator), and page - a page number in a particular database (optional).

```ruby
phones = client.get_phone(base_id)

phones.each do |phone, info|
  phone                     # Getting subscriber number
  info[:name]               # Getting subscriber first name
  info[:middle_name]        # Getting subscriber middle name
  info[:last_name]          # Getting subscriber last name
  info[:date_birth]         # Getting subscriber birthday
  info[:male]               # Getting gender of subscriber
  info[:operator]           # Getting operator of subscriber
  info[:region]             # Getting region of subscriber
  info[:note1]              # Getting subscriber note 1
  info[:note2]              # Getting subscriber note 2
end
```

To receive status info for an SMS you have already sent, use the function get_status(message_id) where message_id - is an array of sent message IDs.

```ruby
statuses = client.get_status(message_id)

statuses.each do |id, status|
  id                        # Getting message ID
  status                    # Getting a message status
end
```

To send a message (to one or several recipients), use the function send(phone, text, sender, sending_time), where phone - is a set of numbers you send your messages to, sender is a sender’s name and text stands for the content of the message and sending_time - Example: 2014-05-30 14:06 (an optional parameter, it is used when it is necessary to schedule SMS messages).

```ruby
statuses = client.send(phone, text, sender, sending_time)

statuses.each do |phone, status|
  phone                     # Getting phone number
  status[:id_sms]           # Getting message ID
  status[:cost]             # Getting price for message
  status[:count_sms]        # Getting number of message parts
  status[:error]            # Getting code error in SMS sending
end
```

To add a number to a stoplist run add_to_stop(phone) where phone is an individual phone number

```ruby
result = client.add_to_stop(phone)
result[:id]                 # return ID in stop list
```

To check if a particular phone number is listed within a stop list use the function find_on_stop(phone), where phone is an individual phone number.

```ruby
check = client.find_on_stop(phone)

check[:description]         # Getting reason of adding to stop list
check[:time_in]             # Getting time of adding to stop list
```

Our gateway supports the option of creating multiple templates of SMS messages. To get a list of templates use the function get_template. As a response you will get a list of all the messages that a certain login has set up.

```ruby
templates = client.get_template
templates.each do |id, info|
  id                        # Getting template ID
  info[:name]               # Getting template name
  info[:template]           # Getting text of template
  info[:up_time]            # Getting the date and time when a particular template was created
end
```

To add a new template to a system run the function add_template(title, template, override) where title is a name of a template, and template is the text content of a template

```ruby
result = client.add_template(title, text)
result[:id]                 # return ID user template
```

To get stats about messages you have sent during a particular month use the function get_stat_by_month(month) where month - is the particular date you need statistics for in the format YYYY-MM.

```ruby
stats = client.get_stat_by_month(month)

stats.each do |date, info|
  date                      # Getting day of month

  info.each do |state, stat|
    state                   # Getting status of message
    stat[:cost]             # Getting prices of message
    stat[:parts]            # Getting number of message parts
  end
end
```

HLR (Home Location Register) - is the centralised databas that provides detailed information regarding the GSM mobile network of every mobile user. HLR requests let you check the availability of a single phone number or a list of numbers for further clean up of unavailable numbers from a contact list. To perform an HLR request, our system supports the function hlr(phone) where phone is the array of phone numbers.

```ruby
result = client.hlr(phones)

result.each do |hlr_data|
  hlr_data[:id]                    # Getting ID
  hlr_data[:destination]           # Getting recipient
  hlr_data[:IMSI]                  # Getting IMSI
  hlr_data[:mccmnc]                # Getting MCC and MNC of subscriber
  hlr_data[:stat]                  # Getting status of subscriber
  hlr_data[:orn]                   # Getting the original name of the subscriber's operator
  hlr_data[:onp]                   # Getting the original prefix of the subscriber's operator
  hlr_data[:ocn]                   # Getting the original name of the subscriber's country
  hlr_data[:ocp]                   # Getting the original code of the subscriber's country
  hlr_data[:pcn]                   # Getting name of country if subscriber's phone number is ported
  hlr_data[:pcp]                   # Getting prefix of country if subscriber's phone number is ported
  hlr_data[:pon]                   # Getting name of operator if subscriber's phone number is ported
  hlr_data[:pnp]                   # Getting prefix of operator if subscriber's phone number is ported
  hlr_data[:rcn]                   # Getting name of country if the subscriber is in roaming
  hlr_data[:rcp]                   # Getting prefix of country if the subscriber is in roaming
  hlr_data[:ron]                   # Getting name of operator if the subscriber is in roaming
  hlr_data[:rnp]                   # Getting prefix of operator if the subscriber is in roaming
  hlr_data[:is_roaming]            # Determining if the subscriber is in roaming
  hlr_data[:is_ported]             # Identification of ported number
end
```

Besides, you can can get HLR requests statistics regarding a certain time range. To do that, use the function get_hlr_stat(from, to) where from and to are the beginning and end of a time period.

```ruby
stats = client.get_hlr_stat(from, to)

stats.each do |number, hlr_data|
  number                           # Getting phone number
  hlr_data[:id]                    # Getting ID
  hlr_data[:destination]           # Getting recipient
  hlr_data[:IMSI]                  # Getting IMSI
  hlr_data[:mccmnc]                # Getting MCC and MNC of subscriber
  hlr_data[:stat]                  # Getting status of subscriber
  hlr_data[:orn]                   # Getting the original name of the subscriber's operator
  hlr_data[:onp]                   # Getting the original prefix of the subscriber's operator
  hlr_data[:ocn]                   # Getting the original name of the subscriber's country
  hlr_data[:ocp]                   # Getting the original code of the subscriber's country
  hlr_data[:pcn]                   # Getting name of country if subscriber's phone number is ported
  hlr_data[:pcp]                   # Getting prefix of country if subscriber's phone number is ported
  hlr_data[:pon]                   # Getting name of operator if subscriber's phone number is ported
  hlr_data[:pnp]                   # Getting prefix of operator if subscriber's phone number is ported
  hlr_data[:rcn]                   # Getting name of country if the subscriber is in roaming
  hlr_data[:rcp]                   # Getting prefix of country if the subscriber is in roaming
  hlr_data[:ron]                   # Getting name of operator if the subscriber is in roaming
  hlr_data[:rnp]                   # Getting prefix of operator if the subscriber is in roaming
  hlr_data[:is_roaming]            # Determining if the subscriber is in roaming
  hlr_data[:is_ported]             # Identification of ported number
  hlr_data[:message_id]            # Getting message ID
  htl_data[:total_price]           # Getting final price of request
  hlr_data[:request_id]            # Getting request ID
  hlr_data[:request_time]          # Getting time of request
end
```

To get information regarding which mobile network a certain phone number belongs to, use the function get_operator(phone), where phone is a phone number.

```ruby
operator = client.get_operator(phone)

operator[:operator]                # Getting operator of subscriber
```

Please bear in mind that this method has less accuracy than HLR requests as it uses our internal database to check which mobile operator a phone numbers belongs to.

To get a list of incoming messages please use the function get_incoming_by_date(date), where date stands for a particular day in YYYY-mm-dd format. Or use the function get_incoming_by_period(from, to), where from - date of start in the format YYYY-MM-DD HH:II:SS (Example: 2014-05-01 14:06:00) and to - date of end in the format YYYY-MM-DD HH:II:SS (Example: 2014-05-30 23:59:59)

```ruby
messages = client.get_incoming_by_date(date)

messages.each do |id, message|
  id                               # Getting message ID
  message[:sender]                 # Getting sender name of the incoming message
  message[:prefix]                 # Getting prefix of the incoming message
  message[:date]                   # Getting date of the incoming message
  message[:text]                   # Getting text of the incoming message
end
```

## Contributing

1. Fork it ( https:#github.com/[my-github-username]/intis-sdk/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
