# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord

    validates :username, presence: true, uniqueness: true
    validates :password_digest, presence: true
    validates :session_token, presence: true, uniqueness: true

    attr_reader :password

    def reset_session_token!
        @token ||= SecureRandom.urlsafe_base64
    end

    def password=(password)
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        @password = BCrypt::Password.create(password)
        @password.is_password?(password)
    end

    def self.find_by_credentials(username, password)
        @user = User.find(username: username)

        if @user && is_password?(password)
            @user
        end
    end

end
