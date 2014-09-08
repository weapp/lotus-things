class User
	attr_accessor :admin
	
	def initialize(admin=false)
		self.admin = admin
	end

  def admin?
  	!!admin
  end

  def id
  	"id"
  end
end
