module Authenticable

  def current_user
    return @current_user if @current_user
    header = request.headers["Authorization"]
              .split(" ")
              .last
    return nil if header.nil?

    decoded = JsonWebTokenService.decode(header)
    @current_user = User.find(decoded["user"])
  end

  def authenticate_user!
    render json: {
      error: "Not authorized"
    } unless current_user
  end

end
