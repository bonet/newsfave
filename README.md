# NewsFave

![Codeship Status](https://www.codeship.io/projects/0a39b9d0-34e2-0131-7ae2-420d7d390c76/status)

[![Coverage Status](https://coveralls.io/repos/bonet/newsfave/badge.png)](https://coveralls.io/r/bonet/newsfave)


## Overview

NewsFave is a website project that provides aggregated RSS feed links from various online sites.  The feed data can be filtered
either by Category or Publisher.  Registered users can choose which newsfeed Categories and Publishers to be shown on their personalized
pages so that they would only see news URLs that are relevant to them.

The newsfeed data themselves are retrieved from a remote server through Feed Webservice API (https://github.com/bonet/feed_webservice).


## Development Environment Setup

1. `git clone git@github.com:bonet/newsfave.git`
2. `bundle install`
3. `cp application.yml.sample application.yml`, and then fill `application.yml` environment variables
4. `cp database.yml.sample database.yml`, and then fill `database.yml` credentials
5. have the PostgreSQL database ready
6. `rake db:migrate`
7. run Guard: `guard`
