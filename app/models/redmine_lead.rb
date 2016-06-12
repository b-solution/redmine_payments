class RedmineLead < ActiveRecord::Base
  unloadable
  include Redmine::SafeAttributes
  
  safe_attributes 'uuid',
                  'type',
                  'website',
                  'strategy_uuid',
                  'click_id',
                  'user_uuid',
                  'email',
                  'name',
                  'address',
                  'country',
                  'city',
                  'zip',
                  'phone',
                  'redirect_url'
end
