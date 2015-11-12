class String
  def oid
    BSON::ObjectId.from_string(self) if BSON::ObjectId.legal?(self)
  end
end
