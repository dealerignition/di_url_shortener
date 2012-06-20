class ShortenUrlController < ApplicationController
  def shorten
    if params[:url] != nil
      if ShortUrl.find_by_url(params[:url]) == nil
        @short_url = ShortUrl.new
      else
        @short_url = ShortUrl.find_by_url(params[:url]) == nil
      end
      @short_url.url = params[:url]
  
      if @short_url.save
        render :json => @short_url
        return
      else
        render :text => "{'error':'could not save URL'}"
        return
      end
    end
    render :json => "{'error':'URL to shorten not supplied'}"
  end
end
