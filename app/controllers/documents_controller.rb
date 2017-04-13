
class DocumentsController < ApplicationController
    before_filter :authenticate_admin!, except: [:index, :show]

 def index
    @category = Category.find(params[:category_id])
    if params[:doc_num] || params[:content] || params[:start_date] || params[:start_date] || params[:doc_type]
      set_session_filter(:doc_num, :content, :start_date, :end_date, :doc_type)
      @documents = filtered_documents.paginate(page: params[:page], per_page: 7).order('id DESC')
    else
     #если был установлен фильтр то очистить
      clear_session_filter(:doc_num, :content, :start_date, :end_date, :doc_type)
      @documents = @category.documents.paginate(page: params[:page], per_page: 7).order('id DESC')
    end
 end

 def new
   @category = Category.find(params[:category_id])
   @document = Document.new
 end

 def edit
   @category = Category.find(params[:category_id])
   @document = @category.documents.find(params[:id])
   session[:return_to] ||= request.referer
 end


 def create
   @category= Category.find(params[:category_id])
   @document = @category.documents.new(document_params)
   respond_to do |format|
     if @document.save
       format.html { redirect_to category_documents_path(@category), notice: ' Документ был успешно создан.' }
     else
       format.html { render :new, error: "не записалось" }
     end
   end
 end

 def show
   @document = Document.find(params[:id])
 end

 def update
   @category= Category.find(params[:category_id])
   @document = @category.documents.find(params[:id])
   if @document.update(document_params)
     redirect_to session.delete(:return_to)
   else
     render 'edit'
   end
 end

 def destroy
   @document = Document.find(params[:id])
   @category = @document.category
   @document.destroy
   redirect_to category_documents_path(@category)
 end

 def import_documents
   @category = Category.find(params[:category_id])
   @category.add_documents
 end

 def load_reference
   @category = Category.find(1)
   @documents = Document.all
   @documents.each do |document|
     @category.documents << document
   end
 end

 def filtered_documents
   @filter_hash ={}
   @filter_str = ''
   set_filter( 'LOWER(content) LIKE ', 'content')
   set_filter( 'LOWER(doc_num) LIKE ', 'doc_num')
   set_filter_date('doc_date>=', 'start_date')
   set_filter_date('doc_date<=', 'end_date')
   set_filter_type( 'doc_type=', 'doc_type')

   if @filter_str.blank?
     @category.documents
   else
     @category.documents.where(@filter_str, @filter_hash)
   end
 end

 private

 def set_filter(comparison, param_name)
   unless params[param_name].blank?
     @filter_hash[param_name.to_sym]= "%"+ params[param_name] + "%"
     @filter_str<<" And " unless @filter_str.blank?
     @filter_str<< comparison<<'LOWER(:'<<param_name<<')'
   end
 end

 def set_filter_date(comparison, param_name)
   unless params[param_name].blank?
     @filter_hash[param_name.to_sym]= params[param_name]
     @filter_str<<" And " unless @filter_str.blank?
     @filter_str<< comparison<<':'<<param_name
   end
 end

 def set_filter_type(comparison, param_name)
   unless params[param_name] =="all"
     @filter_hash[param_name.to_sym]= params[param_name]
     @filter_str<<" And " unless @filter_str.blank?
     @filter_str<< comparison<<':'<<param_name
   end
 end

 def clear_session_filter (*filter_fields)
   filter_fields.each do |param|
     session[param] = nil
   end
 end

 def set_session_filter (*filter_fields)
   filter_fields.each do |param|
     session[param] = params[param]
   end
 end

 def document_params
   params.require(:document).permit(:doc_num, :doc_date, :doc_type, :content, :branch, :geography, :office, :fund, :inventory, :storage_unit, :page, :note)
 end
end
