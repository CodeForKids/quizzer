module ApplicationHelper
  def can_administer?
    email = current_user.try(:email)
    email.present? && (email.end_with?("@codeforkids.ca") || email.end_with?("@code-for-kids.com"))
  end

  def gravatar(email,gravatar_options={})
    grav_url = 'http://www.gravatar.com/avatar.php?'
    grav_url << { :gravatar_id => Digest::MD5.new.update(email), :rating => gravatar_options[:rating], :size => gravatar_options[:size], :default => gravatar_options[:default] }.to_query
    grav_url
  end

  def render_answer_form_helper(answer, form)
    partial = answer.question.type.to_s.split("::").last.downcase
    render partial: "answers/#{partial}", locals: { f: form, answer: answer }
  end

  def checkbox_checked?(answer, option)
    answer.answer_text.to_s.split(",").include?(option)
  end
end
