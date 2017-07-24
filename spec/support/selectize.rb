module Selectize
  def fill_in_selectized(key, value, id)
    page.execute_script(%{$('.selectize-input input').val('#{value}').keyup();})
    sleep(3) #wait_for_ajax didnt see this
    page.execute_script(%{$('##{key}').selectize()[0].selectize.addItem(#{id});})
    # $('.selectize-dropdown-content div').first().attr('data-value')
  end
end
