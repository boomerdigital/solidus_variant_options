SolidusVariantOptions
=====================

Introduction goes here.

Installation
------------

Add solidus_variant_options to your Gemfile:

```ruby
gem 'solidus_variant_options'
```

Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g solidus_variant_options:install
```

Testing
-------

First bundle your dependencies, then run `rake`. `rake` will default to building the dummy app if it does not exist, then it will run specs. The dummy app can be regenerated by using `rake test_app`.

```shell
bundle
bundle exec rake
```

When testing your applications integration with this extension you may use it's factories.
Simply add this require statement to your spec_helper:

```ruby
require 'solidus_variant_options/factories'
```

Copyright (c) 2016 [name of extension creator], released under the New BSD License
