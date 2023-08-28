#---
# Excerpted from "Agile Web Development with Rails 7",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/rails7 for more book information.
#---
class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]

  # GET /products or /products.json
  def index
    @products = Product.all
  end

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html {
          redirect_to product_url(@product),
                      notice: "Product was successfully created."
        }
        format.json {
          render :show, status: :created,
                        location: @product
        }
      else
        format.html {
          render :new,
                 status: :unprocessable_entity
        }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html {
          redirect_to product_url(@product),
                      notice: "Product was successfully updated."
        }
        format.json { render :show, status: :ok, location: @product }

        @product.broadcast_replace_later_to "products",
          partial: "store/product"
      else
        format.html {
          render :edit,
                 status: :unprocessable_entity
        }
        format.json {
          render json: @product.errors,
                 status: :unprocessable_entity
        }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy

    respond_to do |format|
      format.html {
        redirect_to products_url,
                    notice: "Product was successfully destroyed."
      }
      format.json { head :no_content }
    end
  end

  def who_bought
    @product = Product.find(params[:id])
    @latest_order = @product.orders.order(:updated_at).last
    if stale?(@latest_order)
      respond_to do |format|
        format.html
        format.xml
        format.atom
        format.json { render json: @product.to_json(include: :orders) }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def product_params
    params.require(:product).permit(:title, :description, :image_url, :price)
  end
end
