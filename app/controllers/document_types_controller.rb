class DocumentTypesController < ApplicationController
 def index
   @document_types = DocumentType.all
  end

  def new
    @document_type = DocumentType.new
  end

  def create
   @document_type = DocumentType.new(document_type_params)
   respond_to do |format|
     if @document_type.save
       format.html { redirect_to document_types_path, notice: 'Вид документа был успешно создан'}
     else
       format.html { render :new }
       format.json { render json: @category.errors, status: :unprocessable_entity }
     end
   end
  end

  def destroy
     @document_type = DocumentType.find(params[:id])
     @document_type.destroy
     redirect_to document_types_path(@document_type)
  end

  private

  def document_type_params
    params.require(:document_type).permit(:name)
  end

end
