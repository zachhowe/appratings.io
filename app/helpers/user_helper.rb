require 'bcrypt'

class UserHelper
  def self.add_user(username, plain_text_password)
    should_add = !user_exists?(username)

    if should_add
      bcrypt_password = BCrypt::Password.create(plain_text_password)
      
      DataHelper.open('users') do |collection|
        collection.insert({'username' => username, 'password' => bcrypt_password})
      end
    end

    should_add
  end

  def self.remove_user(username)
    should_remove = user_exists?(username)

    if should_remove
      DataHelper.open('users') do |collection|
        collection.remove({'username' => username})
      end
    end
    
    should_remove
  end

  def self.user_exists?(username)
    result = nil

    DataHelper.open('users') do |collection|
      result = collection.find({'username' => username})
    end

    result.count > 0
  end

  def self.authenticate_user(username, plain_text_password)
    doc = nil

    DataHelper.open('users') do |collection|
      doc = collection.find_one({'username' => username}, {:fields => ['password']})
    end

    bcrypt_password = doc['password']
    result = false

    unless bcrypt_password.nil?
      bcrypt_password = BCrypt::Password.new(bcrypt_password)
      result = bcrypt_password == plain_text_password
    end

    result
  end
end
