require_dependency 'project'
module  RedminePayment
  module ProjectPatch
    def self.included(base)
      base.class_eval do
        has_many :products
      end
    end
  end
end
