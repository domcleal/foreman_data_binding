require 'puppet/indirector/terminus'
require 'net/http'
require 'net/https'
require 'uri'

# URL of your Foreman installation
$foreman_url='http://foreman.example.net/'
# if CA is specified, remote Foreman host will be verified
$foreman_ssl_ca = "",
# ssl_cert and key are required if require_ssl_puppetmasters is enabled in Foreman
$foreman_ssl_cert = ""
$foreman_ssl_key = ""

class Puppet::Indirector::Foreman < Puppet::Indirector::Terminus
  def initialize
    raise Puppet::Error, "No $foreman_url supplied" unless $foreman_url
  end

  def uri
    @uri ||= URI.parse($foreman_url)
    @uri
  end

  def create_http
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'
    if http.use_ssl?
      if $foreman_ssl_ca
        http.ca_file = $foreman_ssl_ca
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      else
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      if $foreman_client_ssl
        http.cert = OpenSSL::X509::Certificate.new(File.read($foreman_ssl_cert))
        http.key  = OpenSSL::PKey::RSA.new(File.read($foreman_ssl_key), nil)
      end
    end
    http
  end

  def find
  end
  def search
  end
  def destroy
  end
  def save
  end
end
