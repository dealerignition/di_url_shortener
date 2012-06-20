class RedirectController < ApplicationController
  def redirect
    if @short_url = ShortUrl.find_by_key(params[:key])
      click = Click.new
      click.short_url = @short_url
      click.referrer = request.referrer
      click.ip_address = request.ip
      click.save!
      redirect_to @short_url.url
    else
      render :text => "{'error':'URL not available'}"
    end
  end
end
