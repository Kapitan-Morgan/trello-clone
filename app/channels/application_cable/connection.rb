module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
 
    def connect
      self.current_user = find_verified_user
      unless self.current_user.nil?
        
        logger.add_tags 'ActionCable', self.current_user.login

      end
    end
 
    private
      def find_verified_user
        if current_user = User.find_by(id: cookies.signed['user.id'])
          current_user
        else
          reject_unauthorized_connection
        end
      end
  end
end
