Redmine::Plugin.register :redmine_payments do
  name 'Redmine Payments plugin'
  author 'Bilel KEDIDI'
  description 'This is a plugin for Redmine'
  version '0.0.1'

  project_module :redmine_payments do
    permission :manage_products,
               :products => [:index, :new, :create,
                                     :show, :edit, :update, :destroy]
  end

  menu :project_menu, :redmine_payments,
       { :controller => 'products', :action => 'index' },
       :caption => 'products', :before => :issues, :param => :project_id

  $payment_settings = YAML::load(File.open("#{File.dirname(__FILE__)}/config/setting.yml"))

end

Rails.application.config.to_prepare do
  Project.send(:include, RedminePayment::ProjectPatch)
  ProjectsHelper.send(:include, RedminePayment::ProjectsHelperPatch)

end
Rails.application.config.action_dispatch.default_headers.merge!({
                                                                    'Access-Control-Allow-Origin' => '*',
                                                                    'Access-Control-Request-Method' => '*',
                                                                    'Access-Control-Allow-Headers' => '*'
                                                                })



