module Upstit
  # Generic PackageTracker Error
  class UpstitError < StandardError; end
  
  # Invalid username/password is posted to the server
  class InvalidCredentialsError < UpstitError; end
  
  # The needed credentials to communicate with the server were not given
  class MissingCredentialsError < UpstitError; end
  
  # Either sender- or destinations address are incorrect
  class InvalidAddressError < UpstitError; end
end