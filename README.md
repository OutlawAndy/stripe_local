<a href="http://badge.fury.io/rb/stripe_local"><img src="https://badge.fury.io/rb/stripe_local@2x.png" alt="Gem Version" height="18"></a>
# &spades; _Stripe Local_

A rails engine that maintains a local store of all your Stripe resources, keeping everything up to date with Stripe via their API and Webhook service.
Manages the complexities of keeping two data sources in sync while providing the speed and simplicity of dealing with purely local data in a purely synchronous fashion.

## <b style="color:red;">[</b>UNDER CONSTRUCTION<b style="color:red;">]</b>
### Not considered "Production Ready"

StripeLocal is an attempt at extracting a framework for Stripe Integration that I have built into several medium/large scale CRM projects.

This is my first Rails Engine and I am still learning the ends and outs of building one. If you find something I am doing terribly wrong, please bring it to my attention by opening an issue. I appreciate your help.


### Pull Requests are highly encouraged!
Feel free to fork and hack. You are of course welcome to do want you want with the code. However, I do plan to stay active in developing this code base and would like to see it become a real community effort.

The gem is hosted at [Rubygems.org](https://rubygems.org/gems/stripe_local) like any other gem and is available for use in a Rails project by including it in your gem file

    gem 'stripe_local'

After a `bundle install` you'll need to generate, and run the migrations..

    rake stripe_local:install:migrations && rake db:migrate

### How I see it

StripeLocal overlapse your application in one particular spot, the _customer_

The _customer class_ does not need to be named `Customer`.  It can be any ActiveRecord model, specify which model in your application with a call to a special class macro in the definition

    class MyClassName < ActiveRecord::Base
      stripe_customer
    end

this essentially mixes in a few modules which add a one-to-one relationship with a `Stripe::Customer` and form a `SimpleDelegator` *like* relationship.

Once one of your *customers* has a `Stripe::Customer` you may call methods on your object as if it were itself a `Stripe::Customer`

Use the generated `signup` instance method to create a `Stripe::Customer` linked with your instance.

    my_client.signup({
      card: "card_token",
      plan: "plan_id",
      coupon: "if you want",
      lines: [
        [10099, "this will be a line item on the initial invoice"],
        [100, "optional array of (amount,description) tuples"]
      ]
    })

    my_client.account_balance  #=> 0
    my_client.default_card     #=> card_xxxabc123
    my_client.cards.first.id   #=> card_xxxabc123

You'll need to create a webhook address in your Stripe Account using the Stripe Dashboard. It should point to

    https://yourhostdomain.com/webhook/events

Assuming you had webhooks setup in the previous example.

    my_client.invoices.last.paid?  #=> true
    my_client.charges.last         #=> <#StripeLocal::Charge ch_123abc>

more to come...

## License

&copy; 2014 *[Andy Cohen](mailto:outlawandy@gmail.com?)* (setpoint precision LLC)

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
