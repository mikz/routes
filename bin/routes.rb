
class File
  def File.same_contents(p1, p2)
    return false if File.exists?(p1) != File.exists?(p2)
    return true if File.expand_path(p1) == File.expand_path(p2)
    return false if File.ftype(p1) != File.ftype(p2) || File.size(p1) != File.size(p2)

    open(p1) do |f1|
      open(p2) do |f2|
        blocksize = f1.lstat.blksize
        same = true
        while same && !f1.eof? && !f2.eof?
          same = f1.read(blocksize) == f2.read(blocksize)
        end
        return same
      end
    end
  end
end


# is Dir .roads exist
if Dir.glob(".roads").empty?
  Dir.mkdir(".roads")
end

if File.same_contents("config/routes.rb", ".roads/routes.rb")
  # puts "files identical"
else
  puts "Updating routes cache"
  system "cp config/routes.rb .roads/"
  system "rake routes > .roads/routes.txt"
end

cmd = "cat .roads/routes.txt"
ARGV.each do|a|
  cmd << " | grep -i #{a}"
end

system cmd