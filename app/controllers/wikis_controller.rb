class WikisController < ApplicationController
  
  before_action :authenticate_user!
  
  def index
    @wikis = Wiki.visible_to(current_user)
  end

  def show
    @wiki = Wiki.find(params[:id])
  end

  def new
    @wiki = Wiki.new
  end
  
  def create
    @wiki = Wiki.new(wiki_params)
    
    if @wiki.save
       flash[:notice] = "Wiki was saved successfully."
       redirect_to @wiki
    else
       flash.now[:alert] = "Error creating Wiki. Please try again."
       render :new
    end
  end
    
  def edit
    @wiki = Wiki.find(params[:id])
  end

  def update
    @wiki = Wiki.find(params[:id])
    @wiki.assign_attributes(wiki_params)
 
    if @wiki.save
      flash[:notice] = "Wiki was updated successfully."
      redirect_to @wiki
    else
      flash.now[:alert] = "There was an error saving the Wiki. Please try again."
      render :edit
    end
  end

  def destroy
    @wiki = Wiki.find(params[:id])
 
     if @wiki.destroy
       flash[:notice] = "\"#{@wiki.title}\" was deleted successfully."
       redirect_to wikis_path
     else
       flash.now[:alert] = "There was an error deleting the post."
       render :show
     end
  end


  private
  
  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end

end
