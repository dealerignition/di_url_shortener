class StatsController < ApplicationController
  def stats
    @short_url = ShortUrl.find(params[:id])
  
    if @short_url
      render :json => @short_url.stats
    else
      render :text => "{'error':'URL not available'}"
    end
  end
end
