class Facility < ApplicationRecord
  include Mergeable

  has_many :blood_pressures
  has_many :patients, through: :blood_pressures
  has_many :prescription_drugs

  validates :name, presence: true
  validates :district, presence: true
  validates :state, presence: true
  validates :country, presence: true
end
