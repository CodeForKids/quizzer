module UserHelper

  def image_for_user(user, opts={})
    if user.avatar.url.nil?
      gravatar(user.email, opts)
    else
      user.avatar.url
    end

  rescue
    gravatar(user.email, opts)
  end

  def average_of_groups(groups)
    return 'N/A' if groups.count == 0
    (((groups.inject(0){|sum, group| sum + group.percent_correct })/groups.count)).round(1)

    rescue
      'N/A'
  end
end
