class ProductsController < ApplicationController
  unloadable

  before_action :find_project_by_project_id, except: [:get_products]
  # before_action :authorize, except: [:get_products]


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
    @project.save
    redirect_to :back
  end

  def get_products
    currency = params[:currency]
    products = Product.where(currency: currency)
    if products.blank?
      products = Product.where(currency: 'usd')
    end
    json = products.map{|product| product.attributes.merge!(productid: product.id) }
    render json: json
  end

end
