require_relative 'releaser'
require 'inifile'
require 'pp'
myini = IniFile.load('../src/packaging/texpackvars.ini')
version=myini[:global]['version']
build=myini[:global]['build']
tag="#{version}b#{build}-prerelease"
r=Releaser.new(ENV['GH_TOKEN'], tag, 'Strauman/exercisebank')
r.push
r.upload_asset("../release/exercisebank.sty")
r.upload_asset("../release/exercisebank-doc.pdf")
r.upload_asset("../exercisebank.zip")
# pp r.release
