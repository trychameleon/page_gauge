class Time
  def oid
    BSON::ObjectId.from_time(self)
  end
end
