class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_doc_num, :current_content, :current_start_date, :current_end_date, :current_doc_type

  def current_doc_num
    if session[:doc_num]
      return session[:doc_num]
#      session[:doc_num] = nil
     else
     return ''
    end
  end
  def current_content
    if session[:content]
      return session[:content]
 #     session[:content] = nil
    else
      return ''
    end
  end

  def current_doc_type
    if session[:doc_type]
      return session[:doc_type]
 #     session[:content] = nil
    else
      return ''
    end
  end

  def current_start_date
    if session[:start_date]
      return session[:start_date]
  #    session[:start_date] = nil
     else
     return ''
    end
  end

  def current_end_date
    if session[:end_date]
      return session[:end_date]
   #   session[:end_date] = nil
     else
     return ''
    end
  end

end
