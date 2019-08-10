class Site < ApplicationRecord
  belongs_to :user

  has_many :pages

  accepts_nested_attributes_for :pages, allow_destroy: true

  validates_presence_of :name, :description, :domain, :user
end
