class Page < ApplicationRecord
  belongs_to :site
  belongs_to :user, optional: true

  #Search for pages by name, used in the index action under page controller. credit to Captainmarkos
  #for help refactoring the query.
  
  scope :search_pages, -> (search) {where(Page.arel_table[:name].matches("%#{search}%"))}
  validates_presence_of :name, :path, :header, :body, :photo, :site
  mount_uploader :photo, PhotoUploader

end
