#!/usr/bin/env ruby
require_relative 'releaser'
require 'pathname'
require 'inifile'
require 'pp'
# p ARGV[0]
suggest_num_commits=20
# n_commits=3
FPATH=File.dirname(File.expand_path(__FILE__))
def expath relpath
  exercisebank_abspath=File.dirname(FPATH)
  File.expand_path(File.join(exercisebank_abspath,relpath))
end
ini_path=expath "/src/packaging/texpackvars.ini"
ini_path=File.expand_path(ini_path)
# ini_path="../src/packaging/texpackvars.ini"
myini = IniFile.load(ini_path)
version = myini[:global]['version']
build = myini[:global]['build']
# tag = "#{version}b#{build}-prerelease"
tag = "#{version}b#{build}-experimental"
$current_commit=`git log --pretty=format:'%H' -n 1`
r = Releaser.new(ENV['GH_TOKEN'], tag, 'Strauman/exercisebank')
r.get_release
def make_draft r
  if ARGV.include?("-n")
    n_commits=ARGV[ARGV.index("-n")+1]
  else
    $latest_commits=`git log --pretty=format:'%s' -n #{suggest_num_commits}`
    $latest_commits = $latest_commits.split("\n")
    $latest_commits.map!.with_index{|lc,i| "#{i+1}: #{lc}"}
    puts($latest_commits)
    print "Number of commit messages to include: "
    n_commits=$stdin.gets
  end
  $current_body=`git log --pretty=format:'%B' -n #{n_commits}`
  print $current_body
  # exit 0
  r.push sha: $current_commit, body: $current_body
  r.upload_asset(expath('release/exercisebank.sty'))
  r.upload_asset(expath('release/exercisebank-doc.pdf'))
  # r.upload_asset('../exercisebank.zip')
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
