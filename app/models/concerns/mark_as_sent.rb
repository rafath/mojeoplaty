module MarkAsSent

  def mark_as_sent
    update_attributes(is_sent: true, sent_at: Time.now)
  end

end