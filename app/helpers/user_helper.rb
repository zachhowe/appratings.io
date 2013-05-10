require 'bcrypt'

module UserHelper
  def self.authenticate_user(username, plain_text_password)
    DataHelper.open('users') do |collection|
      doc = collection.find_one({'username' => username}, {:fields => ['password']})
    end

    result = false
    bcrypt_password = doc['password']

    if !bcrypt_password.nil?
      result = plain_text_password == BCrypt::Password.create(bcrypt_password)
    end

    result
  end
end
