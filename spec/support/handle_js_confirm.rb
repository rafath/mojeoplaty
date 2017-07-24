module HandleJsConfirm
  def handle_js_confirm(accept = true)
    result_var = ('a'..'z').to_a.shuffle.first(10).join
    page.execute_script %Q(
      window.#{result_var}_original_confirm_function = window.confirm;
      window.confirm = function(msg) {
        $.cookie('#{result_var}', msg)
        window.confirm = window.#{result_var}_original_confirm_function;
        return #{!!accept};
      };
    )
    yield
    page.evaluate_script("$.cookie('#{result_var}')")
  end
end

