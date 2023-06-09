class JobsController < ApplicationController
  def index
    matching_jobs = Job.all

    @list_of_jobs = matching_jobs.order({ :updated_at => :desc })

    render({ :template => "jobs/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_jobs = Job.where({ :id => the_id })

    @the_job = matching_jobs.at(0)

    render({ :template => "jobs/show.html.erb" })
  end

  def edit
    the_id = params.fetch("path_id")

    matching_jobs = Job.where({ :id => the_id })

    @the_job = matching_jobs.at(0)

    render({ :template => "jobs/edit.html.erb" })
  end

  def create
    the_job = Job.new 
    the_job.firm_name = params.fetch("query_firm_name")
    the_job.role = params.fetch("query_role")
    the_job.job_desc_link = params.fetch("query_job_desc_link")
    the_job.follow_up_link = params.fetch("query_follow_up_link")
    the_job.country = params.fetch("query_country")
    the_job.state = params.fetch("query_state")
    the_job.city = params.fetch("query_city")
    the_job.job_number = params.fetch("query_job_number")
    the_job.job_desc = params.fetch("query_job_desc")
    the_job.status = params.fetch("query_status")
    the_job.user_id = @current_user.id

    user_firms = @current_user.firms

    if user_firms.exists?(firm_name: the_job.firm_name)
      the_job.firm_id = user_firms.find_by(firm_name: the_job.firm_name).id
    else
      the_firm = Firm.new
      the_firm.firm_name = the_job.firm_name  
      the_firm.user_id = @current_user.id    
      the_firm.save
      the_job.firm_id = the_firm.id
    end
   
     
    if the_job.valid?
      the_job.save

      @gpt_questions.each do |a_question|
        the_question = Question.new
        the_question.desc = a_question
        the_question.job_id = the_job.id
        the_question.save
      end

      redirect_to("/jobs", { :notice => "Job created successfully." })
    else
      redirect_to("/jobs", { :alert => the_job.errors.full_messages.to_sentence })
    end
  end

  def create_from_firm
    the_job = Job.new
    the_job.firm_name = params.fetch("query_firm_name")
    the_job.firm_id = params.fetch("query_firm_id")
    the_job.role = params.fetch("query_role")
    the_job.job_desc_link = params.fetch("query_job_desc_link")
    the_job.follow_up_link = params.fetch("query_follow_up_link")
    the_job.country = params.fetch("query_country")
    the_job.state = params.fetch("query_state")
    the_job.city = params.fetch("query_city")
    the_job.job_number = params.fetch("query_job_number")
    the_job.status = params.fetch("query_status")
    the_job.user_id = @current_user.id

    if the_job.valid?
      the_job.save

      @gpt_questions.each do |a_question|
        the_question = Question.new
        the_question.desc = a_question
        the_question.job_id = the_job.id
        the_question.save
      end
      
      redirect_to("/firms/#{the_job.firm_id}", { :notice => "Job created successfully." })
    else
      redirect_to("/firms/#{the_job.firm_id}", { :alert => the_job.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_job = Job.where({ :id => the_id }).at(0)

    the_job.firm_name = params.fetch("query_firm_name")
    the_job.role = params.fetch("query_role").titleize
    the_job.job_number = params.fetch("query_job_number")
    the_job.city = params.fetch("query_city")
    the_job.state = params.fetch("query_state")
    the_job.country = params.fetch("query_country")
    the_job.job_desc_link = params.fetch("query_job_desc_link")
    the_job.follow_up_link = params.fetch("query_follow_up_link")
    the_job.job_desc = params.fetch("query_job_desc")
    the_job.created_at = params.fetch("query_created_at")

    if the_job.valid?
      the_job.save
      redirect_to("/jobs/#{the_job.id}", { :notice => "Job updated successfully."} )
    else
      redirect_to("/jobs/#{the_job.id}", { :alert => the_job.errors.full_messages.to_sentence })
    end
  end

  def update_to_interview
    the_id = params.fetch("path_id")
    the_job = Job.where({ :id => the_id }).at(0)

    the_job.status = "Interview"

    if the_job.valid?
      the_job.save
      redirect_to("/", { :notice => "Job updated successfully."} )
    else
      redirect_to("/", { :alert => the_job.errors.full_messages.to_sentence })
    end
  end

  def update_to_applied
    the_id = params.fetch("path_id")
    the_job = Job.where({ :id => the_id }).at(0)

    the_job.status = "Applied"

    if the_job.valid?
      the_job.save
      redirect_to("/", { :notice => "Job updated successfully."} )
    else
      redirect_to("/", { :alert => the_job.errors.full_messages.to_sentence })
    end
  end

  def update_to_rejected
    the_id = params.fetch("path_id")
    the_job = Job.where({ :id => the_id }).at(0)

    the_job.status = "Rejected"

    if the_job.valid?
      the_job.save
      redirect_to("/", { :notice => "Job updated successfully."} )
    else
      redirect_to("/", { :alert => the_job.errors.full_messages.to_sentence })
    end
  end

  def update_to_interview_from_job
    the_id = params.fetch("path_id")
    the_job = Job.where({ :id => the_id }).at(0)

    the_job.status = "Interview"

    if the_job.valid?
      the_job.save
      redirect_to("/jobs/#{the_job.id}", { :notice => "Job updated successfully."} )
    else
      redirect_to("/jobs/#{the_job.id}", { :alert => the_job.errors.full_messages.to_sentence })
    end
  end

  def update_to_applied_from_job
    the_id = params.fetch("path_id")
    the_job = Job.where({ :id => the_id }).at(0)

    the_job.status = "Applied"

    if the_job.valid?
      the_job.save
      redirect_to("/jobs/#{the_job.id}", { :notice => "Job updated successfully."} )
    else
      redirect_to("/jobs/#{the_job.id}", { :alert => the_job.errors.full_messages.to_sentence })
    end
  end

  def update_to_rejected_from_job
    the_id = params.fetch("path_id")
    the_job = Job.where({ :id => the_id }).at(0)

    the_job.status = "Rejected"

    if the_job.valid?
      the_job.save
      redirect_to("/jobs/#{the_job.id}", { :notice => "Job updated successfully."} )
    else
      redirect_to("/jobs/#{the_job.id}", { :alert => the_job.errors.full_messages.to_sentence })
    end
  end

  def update_to_interview_from_firm
    the_id = params.fetch("path_id")
    the_job = Job.where({ :id => the_id }).at(0)

    the_job.status = "Interview"

    if the_job.valid?
      the_job.save
      redirect_to("/firms/#{the_job.firm_id}", { :notice => "Job updated successfully."} )
    else
      redirect_to("/firms/#{the_job.firm_id}", { :alert => the_job.errors.full_messages.to_sentence })
    end
  end

  def update_to_applied_from_firm
    the_id = params.fetch("path_id")
    the_job = Job.where({ :id => the_id }).at(0)

    the_job.status = "Applied"

    if the_job.valid?
      the_job.save
      redirect_to("/firms/#{the_job.firm_id}", { :notice => "Job updated successfully."} )
    else
      redirect_to("/firms/#{the_job.firm_id}", { :alert => the_job.errors.full_messages.to_sentence })
    end
  end

  def update_to_rejected_from_firm
    the_id = params.fetch("path_id")
    the_job = Job.where({ :id => the_id }).at(0)

    the_job.status = "Rejected"

    if the_job.valid?
      the_job.save
      redirect_to("/firms/#{the_job.firm_id}", { :notice => "Job updated successfully."} )
    else
      redirect_to("/firms/#{the_job.firm_id}", { :alert => the_job.errors.full_messages.to_sentence })
    end
  end

  def update_to_interview_from_edit
    the_id = params.fetch("path_id")
    the_job = Job.where({ :id => the_id }).at(0)

    the_job.status = "Interview"

    if the_job.valid?
      the_job.save
      redirect_to("/jobs/edit/#{the_job.id}", { :notice => "Job updated successfully."} )
    else
      redirect_to("/jobs/edit/#{the_job.id}", { :alert => the_job.errors.full_messages.to_sentence })
    end
  end

  def update_to_applied_from_edit
    the_id = params.fetch("path_id")
    the_job = Job.where({ :id => the_id }).at(0)

    the_job.status = "Applied"

    if the_job.valid?
      the_job.save
      redirect_to("/jobs/edit/#{the_job.id}", { :notice => "Job updated successfully."} )
    else
      redirect_to("/jobs/edit/#{the_job.id}", { :alert => the_job.errors.full_messages.to_sentence })
    end
  end

  def update_to_rejected_from_edit
    the_id = params.fetch("path_id")
    the_job = Job.where({ :id => the_id }).at(0)

    the_job.status = "Rejected"

    if the_job.valid?
      the_job.save
      redirect_to("/jobs/edit/#{the_job.id}", { :notice => "Job updated successfully."} )
    else
      redirect_to("/jobs/edit/#{the_job.id}", { :alert => the_job.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_job = Job.where({ :id => the_id }).at(0)

    the_job.destroy

    redirect_to("/jobs", { :notice => "Job deleted successfully."} )
  end

  def destroy_from_firm
    the_id = params.fetch("path_id")
    the_job = Job.where({ :id => the_id }).at(0)

    the_job.destroy

    redirect_to("/firms/#{the_job.firm_id}", { :notice => "Job deleted successfully."} )
  end

end
