# Nyauth

### application_controller.rb

```ruby
class ApplicationController < ActionController::Base
  include Nyauth::SessionConcern
  self.responder = Nyauth::AppResponder
end
```

### migration

```ruby
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :password_salt, null: false
      t.string :nickname
      t.datetime :confirmed_at
      t.string :confirmation_key
      t.datetime :confirmation_key_expired_at
      t.string :new_password_key
      t.datetime :new_password_key_expired_at

      t.timestamps null: false
    end
    add_index :users, :email, unique: true
  end
end
```

### model

```ruby
class User < ActiveRecord::Base
  include Nyauth::Authenticatable
  include Nyauth::Confirmable
  include Nyauth::NewPasswordAbility
end
```

### config/routes.rb

```ruby
Rails.application.routes.draw do
  mount Nyauth::Engine => "/"
end
```

```
rake routes
```

```
Prefix Verb URI Pattern Controller#Action
nyauth      /nyauth     Nyauth::Engine

Routes for Nyauth::Engine:
            registration POST   /registration(.:format)                         nyauth/registrations#create
        new_registration GET    /registration/new(.:format)                     nyauth/registrations#new
                 session POST   /session(.:format)                              nyauth/sessions#create
             new_session GET    /session/new(.:format)                          nyauth/sessions#new
                         DELETE /session(.:format)                              nyauth/sessions#destroy
           edit_password GET    /password/edit(.:format)                        nyauth/passwords#edit
                password PATCH  /password(.:format)                             nyauth/passwords#update
                         PUT    /password(.:format)                             nyauth/passwords#update
   confirmation_requests POST   /confirmation_requests(.:format)                nyauth/confirmation_requests#create
new_confirmation_request GET    /confirmation_requests/new(.:format)            nyauth/confirmation_requests#new
            confirmation GET    /confirmations/:confirmation_key(.:format)      nyauth/confirmations#update
   new_password_requests POST   /new_password_requests(.:format)                nyauth/new_password_requests#create
new_new_password_request GET    /new_password_requests/new(.:format)            nyauth/new_password_requests#new
       edit_new_password GET    /new_passwords/:new_password_key/edit(.:format) nyauth/new_passwords#edit
            new_password PATCH  /new_passwords/:new_password_key(.:format)      nyauth/new_passwords#update
                         PUT    /new_passwords/:new_password_key(.:format)      nyauth/new_passwords#update
                    root GET    /                                               nyauth/sessions#new
```
