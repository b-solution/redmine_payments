require_dependency 'projects_helper'
module  RedminePayment
  module ProjectsHelperPatch
    def self.included(base)
      base.include(InstanceMethods)
      base.class_eval do
        alias_method_chain :project_settings_tabs, :payment_type
      end
    end
    module InstanceMethods
      def project_settings_tabs_with_payment_type
        tabs = project_settings_tabs_without_payment_type
        tabs<< {:name => 'payments',
                :partial => 'projects/settings/payments',
                :label => 'payments'}
        tabs
      end
    end
  end
end
