require 'puppet/indirector/foreman'
require 'yaml'

class Puppet::DataBinding::Foreman < Puppet::Indirector::Foreman
  desc "Resolve data from Foreman smart class parameters"

  def find(request)
    host = request.options[:variables]["::fqdn"] or raise Puppet::Error, "Can't find ::fqdn"
    ppclass, param = [$1, $2] if request.key =~ /(.+)::([^:]+)/
    raise Puppet::Error, "No ppclass from #{request.key}" unless ppclass
    path = "/param_lookup?format=yml&host=#{CGI.escape(host)}&class=#{CGI.escape(ppclass)}"

    begin
      req = Net::HTTP::Get.new("#{uri.path}#{path}")
      response = create_http.request(req)

      case response
      when Net::HTTPNotFound
        nil
      when Net::HTTPSuccess
        params = YAML.load(response.body)
        return nil unless params[ppclass]
        params[ppclass][param]
      else
        raise Puppet::Error, "Could not retrieve #{request.key} for #{host} from Foreman at #{$foreman_url}#{path}: #{response}"
      end
    rescue Exception => e
      raise Puppet::Error, "Could not retrieve #{request.key} for #{host} from Foreman at #{$foreman_url}#{path}: #{e}"
    end
  end
end
