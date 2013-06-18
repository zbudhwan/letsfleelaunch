class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :registerable, :database_authenticatable,:omniauthable,
         :recoverable, :rememberable, :trackable, :validatable
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :provider, :uid, :name, :picture, :oauth_token
  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name.titleize
      user.picture = auth.info.image
      user.password = Devise.friendly_token[0,20]
      user.email = auth.info.email
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at) unless auth.credtials.expires_at.nil?
      user.save!
    end
  end

def self.new_with_session(params, session)
  if session["devise.user_attributes"]
    new(session["devise.user_attributes"], without_protection: true) do |user|
      user.attributes = params
      user.valid?
    end
  else
    super
  end
end

def password_required?
  super && provider.blank?
end

def update_with_password(params, *options)
  if encrypted_password.blank?
    update_attributes(params, *options)
  else
    super
  end
end
def facebook
		begin
			@facebook ||= Koala::Facebook::API.new(oauth_token)
			block_given? ? yield(@facebook) : @facebook
		rescue Koala::Facebook::APIError => e
			logger.info e.to_s
			nil # or consider a custom null object
		end
	end

	def friends_count
		facebook { |fb| fb.get_connection("me", "friends").size }
	end
end
