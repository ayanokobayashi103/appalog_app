class ShopsController < ApplicationController
  before_action :set_shop, only: %i[show edit update destroy]
  before_action :owner?, only: %i[new ceate edit update]

  def index
    @q = Shop.ransack(params[:q])
    @shops = @q.result(distinct: true).page(params[:page]).per(5)
    # 評価順で並べるばあい
    if params[:sort_top_review]
      @shops = Shop.all.each do |shop|
        shop.average = shop.review_score_average
      end
      @shops = @shops.sort_by { |shop| shop.average }.reverse
      @shops = Kaminari.paginate_array(@shops[0..9]).page(params[:page])
    # クチコミ数の多い順
  elsif params[:review_count]
      @shops = Shop.all.each do |shop|
        shop.review_count = shop.reviews.count
      end
      @shops = @shops.sort_by { |shop| shop.review_count }.reverse
      @shops = Kaminari.paginate_array(@shops).page(params[:page]).per(5)
    end
  end

  def new
    @shop = Shop.new
  end

  def create
    @shop = Shop.new(shop_params)
    @shop.owner_id = current_owner.id
    if @shop.save
      redirect_to shops_path, notice: '新規登録しました'
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @shop.update(shop_params)
      redirect_to owner_path(@shop.owner_id), notice: '店舗の編集をしました'
    else
      render :edit
    end
  end

  def destroy
    @shop.destroy
    redirect_to owner_path(@shop.owner_id), notice: '店舗を削除しました'
  end

  private

  def shop_params
    params.require(:shop).permit(
      :name,
      :brand,
      :address,
      :start_dt,
      :end_dt,
      :detail,
      :url,
      :contact_detail,
      :image,
      :image_cache
    )
  end

  def set_shop
    @shop = Shop.find(params[:id])
  end

  def owner?
    redirect_to shops_path, notice: 'エラー' unless authenticate_owner!
  end
end
