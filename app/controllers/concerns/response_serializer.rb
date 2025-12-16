module ResponseSerializer

  def serialized(resource, serializer)
    serializer.new(resource).serializable_hash
  end
end
