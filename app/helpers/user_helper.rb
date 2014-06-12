module UserHelper

  def average_of_groups(groups)
    (((groups.inject(0){|sum, group| sum + group.percent_correct })/groups.count)).round(1)
  end
end
