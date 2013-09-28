module Upstit
  class TitRequest
    LIVE_URL = "https://onlinetools.ups.com/ups.app/xml/TimeInTransit"
    TEST_URL= "https://wwwcie.ups.com/ups.app/xml/TimeInTransit"
    #include HTTParty
    #base_uri LIVE_URL
    
    attr_accessor  :user_name,:password,:access_license,:options,:client,:client_response,:response,:error
    
    def initialize(user_name, password, access_license, options={})
      @user_name,@password,@access_license,@options = user_name,password,access_license,options
      if @options[:test] == true
        endpoint = TEST_URL
        #self.class.base_uri TEST_URL
      else
        endpoint = LIVE_URL
      end
      wsdl = File.expand_path("../../schema/Time_in_Transit.wsdl", __FILE__)
      @client=Savon.client(endpoint: endpoint, wsdl: wsdl)
      p @client
    end
    
    
    # send previously built request
    def commit
      begin
        @client_response = @client.request  :ns2,"TimeInTransitRequest" do
          soap.header = access_request
          soap.body = build_request
        end
      rescue Savon::SOAP::Fault => fault
              @client_response = fault
      rescue Savon::Error => error
              @client_response = error   
      end
      build_response
    end
    
    def build_request 
      @time_in_transit_hash = build_mandantory_request
      unless options[:weight].nil? 
        @time_in_transit_hash.append(build_weight_hash)
      end
      unless options[:total_packages].nil?
         @time_in_transit_hash.append(build_total_packages_hash)
       end
    end
    
    # Build request with mandantory data
    def build_mandantory_request
      {
        "Request" => {
          "TransactionReference" => {
            "CustomerContext" => [@origin_country_code],
            "XpciVersion" => ["1.0002"]
          },
          "RequestAction"        => ["TimeInTransit"]
        },
        "TransitFrom" => {
          "AddressArtifactFormat" => {
            "PoliticalDivision1" => [@transit_from_political_division],
            "CountryCode" => [@transit_from_country_code],
            "PostcodePrimaryLow" => [@transit_from_postcode_primary_low]
          }
        },
        "TransitTo" => {
          "AddressArtifactFormat" => {
            "PoliticalDivision1" => [@transit_to_political_division],
            "CountryCode" => [@transit_to_country_code],
            "PostcodePrimaryLow" => [@transit_to_postcode_primary_low]
          }
        }  
      }
    end
    
    # Build optional weight hash
    def build_weight_hash
    end
    
    #build optional "total packages in shipment" hash
    def build_total_packages_hash 
    end
    
    def build_response
      
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