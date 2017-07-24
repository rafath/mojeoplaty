class AceCheckbox < Formtastic::Inputs::CheckBoxesInput
  def to_html

  end
end

=begin
class WorkshopSelectorInput < Formtastic::Inputs::CheckBoxesInput

  def initialize(*)
    super
    @options[:label] = false
  end

  def choice_html(workshop)
    choice = [workshop.title, workshop.id,
              {'data-stime'=> workshop.stime, 'data-etime'=> workshop.etime,
               'data-day'=> workshop.day, 'data-autosave'=> false, class: 'workshops'}]

    label = template.content_tag(:label,
      hidden_fields? ?
      check_box_with_hidden_input(choice) :
      check_box_without_hidden_input(choice) <<
      choice_label(workshop),
      label_html_options.merge(:for => choice_input_dom_id(choice), :class => nil)
    )

    description = template.content_tag(:div, template.simple_format(workshop.description), data: {behaviour: 'expand'})
    label + description
  end

  def input_wrapping(&block)
    template.content_tag(:div, class: 'seminars_selector', &block)
  end

  def choices_wrapping(&block)
    template.capture(&block)
  end

  def choices_group_wrapping(&block)
    template.capture(&block)
  end

  def choice_wrapping(html_options, &block)
    input = template.capture(&block)
    button = template.content_tag(:a, 'More Information', class: 'btn btn-small', data: {'behaviour' => 'toggleExpand', 'expand-button-text' => 'More Information', 'hide-button-text' => 'Hide Information'})
    buttons = template.content_tag(:div, button, class: 'buttons')
    template.content_tag(:div, buttons + input, class: 'seminar clearfix', data: {behaviour: 'expandable'})
  end

  def choice_label(choice)
    choice.title
  end

  def collection
    raw_collection
  end

end
=end