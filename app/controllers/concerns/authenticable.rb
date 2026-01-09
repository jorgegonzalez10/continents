module Authenticable

  def current_user
    return @current_user if @current_user

    header = request.headers["Authorization"]
    return nil if header.nil?

    token = header.split(" ").last
    return nil if token.blank?

    begin
      decoded = JsonWebTokenService.decode(token)
      @current_user = User.find_by(id: decoded["user"])
    rescue JWT::DecodeError, JWT::ExpiredSignature
      nil
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end

  def authenticate_user!
    unless current_user
      render json: { error: "Not authorized" }, status: :unauthorized
    end
  end

end
