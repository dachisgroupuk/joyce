module Joyce
  module Scopes
    def since(time)
      self.where(["joyce_activities.created_at > ?", time])
    end
  end
end
