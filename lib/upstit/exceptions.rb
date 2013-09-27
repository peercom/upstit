module Upstit
  # Generic PackageTracker Error
  class UpstitError < StandardError; end
  
  # Invalid username/password is posted to the server
  class InvalidCredentialsError < UpstitError; end
  
  # The needed credentials to communicate with the server were not given
  class MissingCredentialsError < UpstitError; end
  
  # The carrier for the tracking number could not be discerned
  class InvalidAddressError < UpstitError; end
end