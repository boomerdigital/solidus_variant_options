Spree::Admin::OptionValuesController.class_eval do
  def update_positions
    params[:positions].each do |id, index|
      Spree::OptionValue.find(id).update_attributes(position: index)
    end

    respond_to do |format|
      format.js  { render :text => 'Ok' }
    end
  end
end
