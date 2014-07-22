class User < ActiveRecord::Base
  
  #require 'paperclip'

  devise :database_authenticatable, :registerable, :validatable
  
  attr_accessible :username, :email, :password, :password_confirmation
  
=begin
  #Paperclip Stuff
  has_attached_file :avatar, :path           => '/images/:id/:style.:extension',
                                :storage        => :s3,
                                :url            => ':s3_domain_url',
                                :s3_host_alias  => ENV['S3_HOST'],
                                :s3_credentials => { 
                                                     :bucket => ENV['AWS_BUCKET'],
                                                     :access_key_id => ENV['AWS_ACCESS_KEY_ID'],                   
                                                     :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'] 
                                                     },
                                :styles         => {
                                                     #:original => ['1920x1680>', :jpg],
                                                     :small    => ['100x100#',   :jpg],
                                                     #:medium   => ['250x250',    :jpg],
                                                     #:large    => ['500x500>',   :jpg]
                                                     }
                             
  validates_attachment :avatar, :presence => { :if =>  :new_user_or_avatar_parameter_exists? },
                                :size => { :if =>  :new_user_or_avatar_parameter_exists?, :less_than => 5.megabytes },
                                :content_type => { :if =>  :new_user_or_avatar_parameter_exists?, :content_type => ['image/jpeg', 'image/png'] }

  #Paperclip Stuff Ends
=end

  # Method: self.get_newsfeed_aggregate_json
  # Sample Output:
  #
  # {"_id"=>1,
  #  "newsfeed_ids_string"=>"1,2,3,4",
  #  "updated"=>"2013-11-16T04:41:51+07:00",
  #  "newsfeed_aggregate_per_category_ids"=>[1, 2],
  #  "newsfeed_aggregate_per_publisher_ids"=>[1, 2, 3],
  #  "newsfeed_aggregate_per_categories"=>
  #   [{"_id"=>1,
  #     "category_id"=>1,
  #     "category_name"=>"Art",
  #     "newsfeed_aggregate_ids"=>[1],
  #     "newsfeed_ids_string"=>"1,2,3,4"}, 
  #     "content_urls"=>
  #      {"2013-11-15T16:40:28+00:00"=>
  #        [{"title"=>
  #           "At Hemphill Fine Arts, a retrospective show that’s bigger than the gallery",
  #          "link"=>
  #           "http://feeds.washingtonpost.com/c/34656/f/636575/s/33ba6447/sc/4/l/0L0Swashingtonpost0N0Centertainment0Cmuseums0Cat0Ehemphill0Efine0Earts0Ea0Eretr"
  #         }
  #        ],
  #       "2013-11-15T16:29:37+00:00"=>
  #        [{"title"=>
  #           "‘Leger: Modern Art and the Metropolis’ at the Philadelphia Museum of Art",
  #          "link"=>
  #           "http://feeds.washingtonpost.com/c/34656/f/636575/s/33ba0e04/sc/10/l/0L0Swashingtonpost0N0Centertainment0Cmuseums0Cleger0Emodern0Eart0Eand0Ethe0Eme"
  #         }
  #        ]
  #      },
  #    {"_id"=>2,
  #     "category_id"=>2,
  #     "category_name"=>"Technology",
  #     "newsfeed_aggregate_ids"=>[1],
  #     "newsfeed_ids_string"=>"1,2,3,4",
  #     "content_urls"=>
  #      {"2013-11-15T04:08:31+00:00"=>
  #        [{"title"=>
  #           "Runscope Offers New Service To Test Live API Calls For Improving The Quality Of Mobile Apps",
  #          "link"=>
  #           "http://feedproxy.google.com/~r/techcrunchIt/~3/pHIT8TqHrpI/"}
  #        ],
  #       "2013-11-14T23:28:40+00:00"=>
  #        [{"title"=>
  #           "The Omniture Of PR? AirPR's New Analytics Platform Aims To Show CMOs How To Invest In PR",
  #          "link"=>
  #           "http://feedproxy.google.com/~r/techcrunchIt/~3/RlvbTQEfN1U/"}
  #        ]
  #      },
  #    }
  #   ],
  #   "newsfeed_aggregate_per_publishers"=>
  #   [{"_id"=>1,
  #     "publisher_id"=>1,
  #     "publisher_name"=>"Washington Post",
  #     "newsfeed_aggregate_ids"=>[1],
  #     "newsfeed_ids_string"=>"1,2,3,4",
  #     "content_urls"=>
  #      {"2013-11-15T16:40:28+00:00"=>
  #        [{"title"=>
  #           "At Hemphill Fine Arts, a retrospective show that’s bigger than the gallery",
  #          "link"=>
  #           "http://feeds.washingtonpost.com/c/34656/f/636575/s/33ba6447/sc/4/l/0L0Swashingtonpost0N0Centertainment0Cmuseums0Cat0Ehemphill0Efine0Earts0Ea0Eretr
  #          }
  #        ],  
  #       "2013-11-15T16:29:37+00:00"=>
  #        [{"title"=>
  #           "‘Leger: Modern Art and the Metropolis’ at the Philadelphia Museum of Art",
  #          "link"=>
  #           "http://feeds.washingtonpost.com/c/34656/f/636575/s/33ba0e04/sc/10/l/0L0Swashingtonpost0N0Centertainment0Cmuseums0Cleger0Emodern0Eart0Eand0Ethe0Eme
  #         }
  #        ]
  #      }
  #    },
  #    {"_id"=>2,
  #     "publisher_id"=>2,
  #     "publisher_name"=>"New York Times",
  #     "newsfeed_aggregate_ids"=>[1],
  #     "newsfeed_ids_string"=>"1,2,3,4",
  #     "content_urls"=>
  #      {"2013-11-15T20:34:05+00:00"=>
  #        [{"title"=>
  #           "Bits Blog: Finns Pitch Frightful Weather as a Competitive Advantage",
  #          "link"=>
  #           "http://bits.blogs.nytimes.com/2013/11/15/finns-pitch-frightful-weather-as-a-competitive-advantage/?partner=rss&amp;emc=rss"
  #         }
  #        ],
  #       "2013-11-15T20:32:06+00:00"=>
  #        [{"title"=>"Bits Blog: Amazon Bares Its Computers",
  #          "link"=>
  #           "http://bits.blogs.nytimes.com/2013/11/15/amazon-bares-its-computers/?partner=rss&amp;emc=rss"
  #         }
  #        ]
  #      }
  #    },
  #    {"_id"=>3,
  #     "publisher_id"=>3,
  #     "publisher_name"=>"TechCrunch",
  #     "newsfeed_aggregate_ids"=>[1],
  #     "newsfeed_ids_string"=>"1,2,3,4",
  #     "content_urls"=>
  #      {"2013-11-15T04:08:31+00:00"=>
  #        [{"title"=>
  #           "Runscope Offers New Service To Test Live API Calls For Improving The Quality Of Mobile Apps",
  #          "link"=>
  #           "http://feedproxy.google.com/~r/techcrunchIt/~3/pHIT8TqHrpI/"
  #         }
  #        ],
  #       "2013-11-14T23:28:40+00:00"=>
  #        [{"title"=>
  #           "The Omniture Of PR? AirPR's New Analytics Platform Aims To Show CMOs How To Invest In PR",
  #          "link"=>
  #           "http://feedproxy.google.com/~r/techcrunchIt/~3/RlvbTQEfN1U/"
  #         }
  #        ]
  #      }
  #    }
  #   ]
  #  }
  
  def self.get_newsfeed_aggregate_json
    result = Curl.get(Rails.configuration.api_location_get_default_newsfeed_aggregate)
    result_json = (result.response_code == 200) ? JSON.parse(result.body_str) : nil
  end
  
  
  # Method: retrieve_newsfeed_aggregate_json
  # Sample output: same as `self.get_newsfeed_aggregate_json`
  
  def retrieve_newsfeed_aggregate_json
    
    newsfeed_aggregate_json = ""
    
    if self.newsfeed_aggregate_id.blank? == false
      # get personalized
      result = Curl.get(Rails.configuration.api_location_get_personalized_newsfeed_aggregate + self.newsfeed_aggregate_id.to_s)
      newsfeed_aggregate_json = (result.response_code == 200) ? JSON.parse(result.body_str) : nil
    end
    
    if newsfeed_aggregate_json.blank?
      # get default
      result = Curl.get(Rails.configuration.api_location_get_default_newsfeed_aggregate)
      newsfeed_aggregate_json = (result.response_code == 200) ? JSON.parse(result.body_str) : nil
    end   
    
    newsfeed_aggregate_json
  end
  
  
  # Method: self.get_categories_per_publisher_json
  # Sample Output: 
  #
  # {"1"=>
  #   {"publisher_id"=>1,
  #    "publisher_name"=>"Washington Post",
  #    "categories"=>
  #     [{"newsfeed_id"=>2, "category_id"=>1, "category_name"=>"Art"}]},
  #  "2"=>
  #   {"publisher_id"=>2,
  #    "publisher_name"=>"New York Times",
  #    "categories"=>
  #     [{"newsfeed_id"=>3, "category_id"=>2, "category_name"=>"Technology"},
  #      {"newsfeed_id"=>4, "category_id"=>1, "category_name"=>"Art"}]},
  # }
  
  def self.get_categories_per_publisher_json
    result = Curl.get(Rails.configuration.api_location_get_default_categories_per_publisher)
    result_json = (result.response_code == 200) ? JSON.parse(result.body_str) : nil
  end
  
  
  # Method: retrieve_categories_per_publisher_json
  # Sample Output:
  #
  # {"1"=>
  #   {"publisher_id"=>1,
  #    "publisher_name"=>"Washington Post",
  #    "categories"=>
  #     [{"newsfeed_id"=>2,
  #       "category_id"=>1,
  #       "category_name"=>"Art",
  #       "owned"=>"true"}]},
  #  "2"=>
  #   {"publisher_id"=>2,
  #    "publisher_name"=>"New York Times",
  #    "categories"=>
  #     [{"newsfeed_id"=>3,
  #       "category_id"=>2,
  #       "category_name"=>"Technology",
  #       "owned"=>"true"},
  #      {"newsfeed_id"=>4,
  #       "category_id"=>1,
  #       "category_name"=>"Art",
  #       "owned"=>"false"}]}
  # }
  
  def retrieve_categories_per_publisher_json
    api_location = self.newsfeed_aggregate_id.blank? ? Rails.configuration.api_location_get_default_categories_per_publisher : Rails.configuration.api_location_get_personalized_categories_per_publisher + self.newsfeed_aggregate_id.to_s

    result = Curl.get(api_location)
    categories_per_publisher_json = (result.response_code == 200) ? JSON.parse(result.body_str) : nil
  end 
  
  
  def subscribe_to_newsfeeds(newsfeed_ids)
    result = Curl::Easy.http_post(Rails.configuration.api_location_create_personalized_newsfeed_aggregate, 
                                  Curl::PostField.content('newsfeed_ids', newsfeed_ids))
    newsfeed_aggregate = (result.response_code == 200) ? JSON.parse(result.body_str) : nil
    
    unless newsfeed_aggregate['_id'].nil?
      self.newsfeed_aggregate_id = newsfeed_aggregate['_id']
      self.save
    end
  end

end
