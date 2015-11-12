module BSON
  class ObjectId
    def oid
      self
    end

    def as_json(*)
      to_s
    end
  end
end
