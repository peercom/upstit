module Upstit
  class TitRequest
    LIVE_URL = "https://onlinetools.ups.com/ups.app/xml/TimeInTransit"
    TEST_URL= "https://wwwcie.ups.com/ups.app/xml/TimeInTransit"
    
    attr_accessor  :user_name,:password,:access_license,:options,:client,:client_response,:response,:error
    
    def initialize(user_name, password, access_license, options={})
      @user_name,@password,@access_license,@options = user_name,password,access_license,options 
      @client=Savon::Client.new(File.expand_path("../../schema/Time_in_Transit.wsdl", __FILE__))
      set_environment
    end
    
    # For Test environment set test url
    def set_environment
      if @options[:test] == true
        @client.wsdl.endpoint = TEST_URL
        self.class.base_uri TEST_URL
      else 
        @client.wsdl.endpoint = LIVE_URL
      end   
    end
    
    #Setup authentication
    def access_request
      {   
        "ns3:UPSSecurity" => {
          "ns3:UsernameToken"=>{
            "ns3:Username"=>@user_name,
            "ns3:Password" => @password
          },
          "ns3:ServiceAccessToken"=>{
            "ns3:AccessLicenseNumber"=> @access_license
          }
        }
      } 
    end
        
  end
end