class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  http_basic_authenticate_with name: "admin", password: "admin", except: [:index, :show]

  # GET /categories
  # GET /categories.json
  def index
    @categories = Category.all
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
    if params[:doc_num] || params[:content]
    session[:doc_num] = params[:doc_num]
    session[:content] = params[:content]
    @documents =filtered_documents.paginate(:page => params[:page],:per_page => 10).order('id DESC')
    else
      @documents = @category.documents.paginate(:page => params[:page], :per_page => 10).order('id DESC')
    end
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)
    respond_to do |format|
      if @category.save
        format.html { redirect_to categories_path, notice: 'Категория была успешно создана'}
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to @category, notice: 'Категория была успешно изменена' }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    respond_to do |format|
      if @category.documents.empty?
        @category.destroy
        format.html { redirect_to categories_url, notice: 'Категория была удалена.' }
      else
        logger.info 'else'
        format.html { redirect_to categories_url, :flash => {:error => 'Нельзя удалять категорию, у нее есть связанные документы.'} }
      end
    end
  end

  def filtered_documents
    @filter_hash ={}
    @filter_str = ''
    set_filter( 'LOWER(content) LIKE ', 'content')
    set_filter( 'LOWER(doc_num) LIKE ', 'doc_num')
    if @filter_str.blank?
      @category.documents
    else
      @category.documents.where(@filter_str, @filter_hash)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    def set_filter(comparison, param_name)
        unless params[param_name].blank?
          @filter_hash[param_name.to_sym]= "%"+ params[param_name] + "%"
          @filter_str<<" And " unless @filter_str.blank?
          @filter_str<< comparison<<'LOWER(:'<<param_name<<')'
        end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name)
    end
end
