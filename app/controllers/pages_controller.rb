class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  #Added index.json.jbuilder
  def index
    if params[:search]
      @search_results_pages = Page.search_pages(params[:search])
      respond_to do |format|
        format.js { render partial: 'search-results'}
      end
    else
      if !@ZR_USER
        # If no user, redirect to login.
        redirect_to '/users/sign_in'
      else
        @pages = Page.where(user: @ZR_USER.id)
      end
    end
  end

  def new
    @page = Page.new
  end

  #Only modification made on create was I added respond_to f.js in order to allow for an AJAX call.

  def create
    @page = Page.create(page_params)
    flash[:alert] = "Site Error: #{@page.errors.full_messages.join(', ')}" unless @page.persisted?
    respond_to do |f|
      f.html { redirect_to  }
      f.json { render :show, status: :created, location: @pages }
      f.js do
        @site = Site.find(page_params[:site_id])
      end
    end
  end

  #Udpate is triggered by a js function located in application.js that submits the form on keypress.
  #On submit, we find the record, and update attributes. If the user leaves a field blank, a
  #alert notifies the user the data wasn't saved.

  def update
    @page = Page.find(params[:id])
    if @page.update_attributes(page_params)
      respond_to do |f|
        f.js {flash.now[:notice] = "Page info has been updated!"}
      end
    else
      flash.now[:alert] = "Error: Field Required! "
    end
  end

  # Show method should respond with HTML or JSON
  def show
    @ZR_PAGE
    @page = Page.find(params[:id])
  end

  def destroy
    @page = Page.find(params[:id])
    if @page.present?
      @page.destroy
    end
    respond_to do |format|
      format.js { render :layout => false }
      format.html { redirect_to sites_url, notice: 'Site was successfully destroyed.' }
    end
  end

  private

  def page_params
    params.require(:page).permit(:name, :path, :header, :body, :photo_cache, :photo, :site_id, :user_id)
  end
end
