class Admin::EmbeddableHostsController < ApplicationController

  before_filter :ensure_logged_in, :ensure_staff

  def update
    host = EmbeddableHost.where(id: params[:id]).first
    host.host = params[:embeddable_host][:host]
    host.category_id = params[:embeddable_host][:category_id]
    host.category_id = SiteSetting.uncategorized_category_id if host.category_id.blank?

    host.save

    render_serialized(host, EmbeddableHostSerializer, root: 'embeddable_host', rest_serializer: true)
  end

end
