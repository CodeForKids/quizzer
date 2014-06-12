module UserHelper

  def average_of_groups(groups)
    return 'N/A' if groups.count == 0
    (((groups.inject(0){|sum, group| sum + group.percent_correct })/groups.count)).round(1)
  end
end
