class CollaboratorsController < ApplicationController
    
    def create
        user = User.where(email: params[:email]).first
        wiki = Wiki.find(params[:wiki_id])
        
        # no user, raise error and redirect
        if user.nil?
            flash[:error] = "User with #{params[:email]} was not found"
        
        # user is self, raise error and redirect
        elsif user.id == current_user.id
            flash[:alert] = 'Cannot add self as collaborator'
        
        # user AND collaborators, raise error and redirect
        elsif wiki.users.include?(user)
            flash[:error] = "User with email #{params[:email]} already exists as a collaborator"
                
        # user and no collaborator, create collaborator and populate message and redireect
        else 
            if Collaborator.create(user: user, wiki: wiki)
                flash[:alert] = 'Collaborator has been added'
        
            else
                flash[:error] = "Error - Collaborator could not be added." 
            end
        end
        
        redirect_to edit_wiki_path(wiki)
    end
    
    def destroy
        collaborator = Collaborator.find(params[:id])
        wiki = Wiki.find(params[:wiki_id])
        
        collaborator.delete
        
        flash[:alert] = "Collaborator has been removed"
        
        redirect_to edit_wiki_path(wiki)
    end
end