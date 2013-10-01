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
      @client=Savon.client(endpoint: endpoint, wsdl: wsdl, ssl_verify_mode: :none, pretty_print_xml: true)
      
    end
    
    
    # send previously built request
    def commit
      begin
        @client_response = @client.call(:process_time_in_transit, :xml => build_xml)
      rescue Savon::SOAPFault => fault
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
       @time_in_transit_hash
    end
    
    def build_xml
      "<?xml version='1.0'?>
      <AccessRequest xml:lang='en-US'>
        <AccessLicenseNumber>#{@access_license}</AccessLicenseNumber>
        <UserId>#{@user_name}</UserId>
        <Password>#{@password}</Password>
      </AccessRequest>
      <?xml version='1.0'?>
      <TimeInTransitRequest xml:lang='en-US'> 
        <Request>
          <TransactionReference>
            <CustomerContext>#{options[:origin_country_code]}</CustomerContext> 
            <XpciVersion>1.0002</XpciVersion>
          </TransactionReference>
          <RequestAction>TimeInTransit</RequestAction> 
        </Request>
        <TransitFrom> 
          <AddressArtifactFormat>
            <PoliticalDivision2>#{options[:transit_from_political_division2]}</PoliticalDivision2>
            <PoliticalDivision1>#{options[:transit_from_political_division1]}</PoliticalDivision1> 
            <CountryCode>#{options[:transit_from_country_code]}</CountryCode> 
            <PostcodePrimaryLow>#{options[:transit_from_postcode_primary_low]}</PostcodePrimaryLow>
          </AddressArtifactFormat> 
        </TransitFrom>
        <TransitTo> 
          <AddressArtifactFormat>
            <PoliticalDivision2>#{options[:transit_to_political_division2]}</PoliticalDivision2>
            <PoliticalDivision1>#{options[:transit_to_political_division1]}</PoliticalDivision1> 
            <CountryCode>#{options[:transit_to_country_code]}</CountryCode> 
            <PostcodePrimaryLow>#{options[:transit_to_postcode_primary_low]}</PostcodePrimaryLow>
          </AddressArtifactFormat>
        </TransitTo>
        <ShipmentWeight>
          <UnitOfMeasurement> 
            <Code>#{options[:unit_of_measurement]}</Code> 
          </UnitOfMeasurement>
          <Weight>#{options[:weight]}</Weight>
        </ShipmentWeight>
        <InvoiceLineTotal>
          <CurrencyCode>USD</CurrencyCode>
          <MonetaryValue>250.00</MonetaryValue> 
        </InvoiceLineTotal>
        <PickupDate>20131002</PickupDate>
      </TimeInTransitRequest>"
    end
    
    def build_response
      
    end
        
  end
end