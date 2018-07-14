class PeopleController < ApplicationController

  # Paging - take in page and per_page params
  # Do we want counts for pages or for whole dataset?
  # paginate(page: page, per_page: per_page)
  def index
    begin
      @people = API::SalesloftService.people
      @people.sort_by! { |p| p.email }
    rescue API::SalesloftService::SalesloftError => e
      flash[:alert] = e
      @people = []
    end

    helper = PeopleService.new(@people)
    @characters = helper.count_email_characters
    @duplicates = helper.find_duplicate_emails
  end
end
