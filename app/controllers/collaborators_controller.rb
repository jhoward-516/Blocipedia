class CollaboratorsController < ApplicationController
    
    def create
        @user = User.find_by!(params[:email])
        @wiki = Wiki.find_by(params[:id])
        
        # no user, raise error and redirect
        rescue ActiveRecord::RecordNotFound
        redirect_to(edit_wiki_path(@wiki), :error => 'User not found')
        
        # user is self, raise error and redirect
        if @user.id == current_user.id
            redirect_to(edit_wiki_path(@wiki), :alert => 'Cannot add self as collaborator')
        
        # user AND collaborators, raise error and redirect
        elsif @wiki.users.include?(@user)
            redirect_to(edit_wiki_path(@wiki), :error => 'User already exists as a collaborator')
                
        # user and no collaborator, create collaborator and populate message and redireect
        elsif
            redirect_to(edit_wiki_path(@wiki), :alert => 'Collaborator has been added')
        
        else
            flash[:error] = "Error - Collaborator could not be added." 
            redirect_to edit_wiki_path(@wiki) 
        end
    end
    
    def destroy
    end
end