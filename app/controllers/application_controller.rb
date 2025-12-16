class ApplicationController < ActionController::API
  include Authenticable
  include ResponseSerializer
end
