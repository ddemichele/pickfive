class User < ActiveRecord::Base

  self.table_name = "user"
  has_many :picks
  has_many :user_results

 # attr_accessor :password, :firstname, :lastname, :username, :slips

  @version
  @subdiv
  @enabled
  
  #before_save :encrypt_password, :setRequiredVars
  after_save :clear_password
  
  EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  validates :username, :presence => true, :uniqueness => true
  #validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX
  #validates :password, :confirmation => true


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
    logger.debug " IN ENCRYPT PASSWORD"
    unless password.blank?
      self.password = Digest::SHA256.hexdigest(password)
    end
  end

  def setRequiredVars
    logger.debug " IN SET REQUIRED VARS"
    self.version = 1
    self.subdiv = 1
    #self.enabled = true
  end

  def clear_password
    self.password = nil
  end

  # Check to see if a user is an admin
  def isAdmin
    
  end

end
