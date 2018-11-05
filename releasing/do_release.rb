require_relative 'releaser'
require 'inifile'
require 'pp'
# p ARGV[0]
myini = IniFile.load('../src/packaging/texpackvars.ini')
version = myini[:global]['version']
build = myini[:global]['build']
tag = "#{version}b#{build}-prerelease"
$current_commit=`git log --pretty=format:'%H' -n 1`
r = Releaser.new(ENV['GH_TOKEN'], tag, 'Strauman/exercisebank')
r.get_release
def make_draft r
  r.push sha: $current_commit
  r.upload_asset('../release/exercisebank.sty')
  r.upload_asset('../release/exercisebank-doc.pdf')
  r.upload_asset('../exercisebank.zip')
end
if ARGV.include?('--delete')
  r.get_release
  unless r.release.nil?
    r.delete
    r.get_release!
  end
else
  if r.release.nil?
    make_draft r
  elsif ARGV.include?('-f')
    r.delete
    r.get_release!
    make_draft r
  end
  unless r.release.nil?
    if r.release[:draft]
      r.publish if ARGV.include?('--publish')
    end
  end
  if r.release[:draft]
    p 'DRAFT'
  else
    p 'NDRAFT'
  end
end
pp r.release
