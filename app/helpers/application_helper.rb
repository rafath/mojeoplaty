module ApplicationHelper

  def image_tag(source, options = {})
    #image_tag "/assets/spinner.gif", "data-original" => "path_to_image", :class =>"class1 lazy", :size => "100x100
    options[:title] = h(options[:alt]).strip
    options[:alt] = options[:title]
    if !options[:lazy].blank? and options[:lazy] == 1
      options['data-href'] = source
      options[:class] = "#{options[:class]} lazy".strip
      source = 'loader.gif'
    end
    super(source, options)
  end

  def png(image, options = {})
    image_tag(asset_path("#{image}.png"), options)
  end

  def jpg(image, options = {})
    image_tag(asset_path("#{image}.jpg"), options)
  end

  def gif(image, options = {})
    image_tag(asset_path("#{image}.gif"), options)
  end


  def ge(name, sufix=:es)
    sufixes = {
        :es => 'eś',
        :y => 'y',
        :a => '',
    }
    if name.present? and name[-1] == 'a'
      sufixes = {
          :es => 'aś',
          :y => 'a',
          :a => 'a',
      }
    end
    sufixes[sufix]
  end

  def set_price(price, clear=false, vat=false)

    price = price*vat unless vat.blank? #due to english company
    price = number_to_currency(price, {unit: 'zł', separator: ',', delimiter: ' ', format: '%n %u'})
    #return price if clear
    raw(price)
  end

  def time_ago_in_words(date, text='dodano')
    content = super(date) +' '+ t(:ago)
    content = "<span class='time-ago'>#{text} #{content}</span>" if text.present?
    raw(content)
  end

  def is_logged?
    !current_user.nil?
  end

  def tax_offices_for_city(city)
    offices = []
    TaxOffice.search_by_city(city).collect do |office|
      offices[office.id] = office.full_name
    end
    offices
  end

  def fa_icon(name)
    raw("<i class='fa fa-#{name} ace-icon'></i>")
  end

  def show_model_errors(resource)
    content = ''
    if resource.errors.present? and resource.errors.messages.present?
      resource.errors.messages.each_pair do |attr, errors|
        content << content_tag(:li) do
          concat content_tag(:strong, resource.class.human_attribute_name(attr))
          concat build_error_messages(errors)
        end
      end
      content_tag(:div, class: 'panel panel-danger') do
        content_tag(:div, 'Przepraszamy wystąpiły błędy', class: 'panel-heading') +
            content_tag(:div, class: 'panel-body') do
              concat content_tag(:ul, content.html_safe, class: 'errors danger')
            end
      end
    end
  end

  def title(page_title='')
    if page_title.blank?
      page_title = 'Moje Opłaty - System Informacji o składkach ZUS i podatkach US'
    else
      page_title = "Moje Opłaty - #{page_title}"
    end
    content_for(:title, page_title.to_s)
  end

  def show_uploader_errors(uploader)
    content = ''

    content_tag(:div, class: 'panel panel-danger') do
      content_tag(:div, 'Przepraszamy wystąpiły błędy', class: 'panel-heading') +
          content_tag(:div, class: 'panel-body') do
            # concat content_tag(:ul, content.html_safe, class: 'errors danger')
            content_tag(:ul, class: 'errors danger') do
              uploader.errors.each do |e|
                concat content_tag(:li, e)
              end
            end
          end
    end
  end

  def build_error_messages(errors)
    content_tag(:ul, class: 'messages') do
      errors.each do |err|
        concat content_tag(:li, err)
      end
    end
  end


  def payments_dates
    date = Time.now
    next_month = date+1.month

    zus_date = date.day > 15 ? next_month : date
    zus = content_tag(:strong, l(zus_date, format: '10 lub 15 %B').downcase)

    tax_date = date.day > 20 ? next_month : date
    tax = content_tag(:strong, l(tax_date, format: '20 %B').downcase)

    vat_date = date.day > 25 ? next_month : date
    vat = content_tag(:strong, l(vat_date, format: '25 %B').downcase)

    content = content_tag(:p, raw("Składki ZUS: #{zus}"))
    content << content_tag(:p, raw("Podatek Dochodowy: #{tax}"))
    content << content_tag(:p, raw("Podatek VAT: #{vat}"))

    content

  end

end
