# get puppet classes and transform them into facts
vars = []

# sample code to parse puppet config file from puppet_varlib.rb (puppet stdlib)
def self.with_puppet
  begin
    Module.const_get("Puppet")
  rescue NameError
    nil
  else
    yield
  end
end

# Identify classes file
file=nil
vardir=nil
self.with_puppet do
  file = Puppet[:classfile]
  vardir = Puppet[:vardir]
end
if ! File.exist?(file)
  file = "#{vardir}/classes.txt"
end


# set facts
if File.exist?(file)
  File.open(file).each do |line|
    vars.push line.chomp
  end
end
Facter.add("puppetclasses") do
  setcode do
    vars.join(",")
  end
end
vars.each do |i|
  Facter.add("puppetclass_#{i}") do
    setcode do
      1
    end
  end
end

