class ProductsController < ApplicationController
  unloadable

  before_action :find_project_by_project_id, except: [:get_products]
  before_action :verify_authenticity_token, only: [:get_products]


  def verify_authenticity_token

  end

  def index
    @limit = per_page_option
    @products_count =  @project.products.count
    @products_pages = Paginator.new @products_count, @limit, params['page']
    @offset ||= @products_pages.offset

    @products = @project.products( :offset => @offset,
                                   :limit => @limit)
  end

  def new
    @product = Product.new(project_id: @project.id)
  end

  def create
    @product = Product.new(project_id: @project.id)
    @product.safe_attributes = params[:product].permit!
    if @product.save
      Product::CURRENCIES.each do |currency|
        price = PriceCurrency.new
        price.currency = currency
        price.product_id = @product.id
        price.safe_attributes = params[currency].permit!
        price.save
      end
      redirect_to project_product_path(@project, @product)
    else
      render 'new'
    end

  end

  def show
    @product = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end


  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    @product.safe_attributes = params[:product].permit!
    if @product.save
      Product::CURRENCIES.each do |currency|
        price = @product.price_currencies.where(currency: currency).first_or_initialize
        price.currency = currency
        price.product_id = @product.id
        price.safe_attributes = params[currency].permit!
        price.save
      end
      redirect_to project_product_path(@project, @product)
    else
      render 'edit'
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to project_products_path
  end

  def set_payment_type
    @project.payment_type = params[:payment_type].first
    @project.stripe_key = params[:stripe_key]
    @project.save
    redirect_to :back
  end

  def get_products
    currency = params[:currency]
    unless Product::CURRENCIES.include?(currency)
     currency = 'usd'
    end
    scope = Product.where(nil)


    if params[:group]
     scope = scope.where('products.group = ?', params[:group])
    end

    if params[:slug]
      scope = scope.where('products.slug = ?', params[:slug])
    end

    if params[:project_id]
      scope = scope.where('products.project_id = ?', params[:project_id])
    end

    unless params[:hidden] or params[:showhidden]
      scope = scope.where('products.active = ?', true)
    end


    json = scope.map{|pc| pc.to_json(currency) }
    render json: json
  end

end
