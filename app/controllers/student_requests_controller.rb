class StudentRequestsController < ApplicationController


  def index
    @hold_requests = HoldRequest.where(user_id: session[:user_id]).to_a
    @specical_book_requests = Request.where.not(isbn: [nil, ''], status: [1, 2]).to_a
    @student_requests = @hold_requests.concat(@specical_book_requests)
  end

  def set_hold_request
    @hold_request = HoldRequest.find(params[:id])
  end



end