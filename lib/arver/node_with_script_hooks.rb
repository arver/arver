module Arver
  module NodeWithScriptHooks 
    attr_accessor :pre_open, :pre_close, :post_open, :post_close
    def script_hooks_to_yaml
      yaml = ""
      yaml << "'pre_open': '#{pre_open}'\n" unless pre_open.nil?
      yaml << "'pre_close': '#{pre_close}'\n" unless pre_close.nil?
      yaml << "'post_open': '#{post_open}'\n" unless post_open.nil?
      yaml << "'post_close': '#{post_close}'\n" unless post_close.nil?
      yaml
    end
    def script_hooks_from_hash( hash )
      hash.each do | name, data |
        self.pre_open= data if name == "pre_open"
        self.pre_close= data if name == "pre_close"
        self.post_open= data if name == "post_open"
        self.post_close= data if name == "post_close"
      end
      hash.delete("pre_open") 
      hash.delete("pre_close") 
      hash.delete("post_open") 
      hash.delete("post_close") 
    end
  end
end
