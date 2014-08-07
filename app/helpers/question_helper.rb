module QuestionHelper
  include BootstrapWidgets

  def correct_widget(question)
    corrects = question.answers.collect { |a| a.correct? }
    correct = corrects.count(true)
    percent = (correct/corrects.count.to_f*100).round(0) rescue 0
    "#{correct} of #{corrects.count} (#{percent.to_s}%) got this right"
  end

  def num_correct(question)
    corrects = question.answers.collect { |a| a.correct? }
    correct = corrects.count(true)
    percent = (correct/corrects.count.to_f*100).round(0) rescue 0
    "#{correct} of #{corrects.count} (#{percent.to_s}%) got this right"
  end

  def quiz_correct_widget(question_group)
    answer_groups = @question_group.answer_groups
    sum = answer_groups.collect { |ag| ag.percent_correct }.inject(:+) || 0

    unless answer_groups.empty?
      data = (sum / answer_groups.count).round(2)
    else
      data = 0
    end

    DashboardWidget.new('', 'single_text', {}, { "Average mark on Quiz" => data.to_s + "%" })
  end

  def distribution_widget(question_group)
    widget = DashboardWidget.new('Mark Distribution', 'line_graph', {})
    answer_groups = @question_group.answer_groups
    data = answer_groups.collect { |ag| ["#{ag.user.name}-#{ag.id}", ag.percent_correct] }
    data.sort! { |a,b| a[1] <=> b[1] }
    data.each do |num|
      widget.add_data_pair(num[0], num[1])
    end
    widget
  end

end
