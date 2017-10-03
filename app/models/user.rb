class User < ActiveRecord::Base

  self.table_name = "user"
  has_many :picks
  has_many :user_results

  @version
  @subdiv
  @enabled
  
  before_save :encrypt_password, :setRequiredVars
  after_save :clear_password
  
  EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  validates :username, :presence => true, :uniqueness => true, :length => { :in => 3..20 }
  #validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX
  validates :password, :confirmation => true
  #Only on Create so other actions like update password attribute can be nil
  validates_length_of :password, :in => 6..20, :on => :create

  #attr_accessor :username, :password, :firstname, :lastname, :slips
  #attr_accessible :username, :password, :firstname, :lastname, :slips


  def self.authenticate(username_or_email="", login_password="")

    if  EMAIL_REGEX.match(username_or_email)    
    #  user = User.find_by_email(username_or_email)
    #else
      user = User.find_by_username(username_or_email)
    end

    if user && user.match_password(login_password, user.password)
      return user
    else
      return false
    end
  end   

  def match_password(login_password="", user_password="")
    passwordEncrypt = Digest::SHA256.hexdigest(login_password)
    if user_password == passwordEncrypt
      logger.debug "passwords match"
      return true
    else
      logger.debug "passwords dont match"
      return false
    end
  end



  def encrypt_password
    #self.version = 1
    unless password.blank?
      self.password = Digest::SHA256.hexdigest(password)
    end
  end

  def setRequiredVars
    self.version = 1
    self.subdiv = 1
    self.enabled = 1
  end

  def clear_password
    self.password = nil
  end

  # Check to see if a user is an admin
  def isAdmin
    
  end

end
