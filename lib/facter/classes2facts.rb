# get puppet classes and transform them into facts
vars = []

case Facter.value(:kernel)
when "Linux"
  file = "/var/lib/puppet/classes.txt"
  if ! File.exist?(file)
    file = "/var/lib/puppet/state/classes.txt"
  end
else
  file = ""
end

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
