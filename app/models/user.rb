class User < ActiveRecord::Base

  #Associations
  has_one :subject, :foreign_key => 'employee_id'
  has_one :admissions, :foreign_key => 'user_id'
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  attr_accessor :login
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:login]

  validates_presence_of :user_name
  validates_uniqueness_of :user_name
  validates :user_name, length: { in: 4..20 }
  validates_presence_of :user_type

  def full_name
    (first_name + " " + last_name) rescue ''
  end
  
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(user_name) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  #name
  def name
    "#{self.first_name} #{self.last_name}"
  end
end
