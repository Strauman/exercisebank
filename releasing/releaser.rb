require 'octokit'
# require 'filemagic'
require 'pp'
class Releaser
  attr_accessor :release_tag, :release, :cli
  def initialize(token, tag, repo)
    @token = token
    @release_tag = tag
    @repo = repo
    @release_opts = {}
    connect
  end

  def connect
    @cli = Octokit::Client.new(access_token: @token)
  end

  def set(**options)
    @release_opts = options
  end

  def create(options)
    latest_commit = cli.commits(@repo).first
    opts = {
      title: "Release #{@release_tag}",
      body: latest_commit[:commit][:message],
      prerelease: true,
      draft: true,
      sha: latest_commit[:sha]
    }.update(options)
    # @cli.create_ref(@repo,"tags/#{@release_tag}", opts[:sha])
    @release = @cli.create_release(repo = @repo, tag_name = @release_tag,
                                   target_commitish: opts[:sha],
                                   name: opts[:title],
                                   body: opts[:body],
                                   draft: opts[:draft],
                                   prerelease: opts[:prerelease])
  end

  def update(options)
    @release = @cli.update_release(@release[:url], options)
  end

  def push(**options)
    @release_opts.update(options)
    get_release
    if @release.nil?
      create @release_opts
    else
      update @release_opts
    end
  end

  def upload_asset(file, **options)
    opts = { content_type: 'application/octet-stream' }.update(options)
    @cli.upload_asset(@release[:url], file, opts)
  end

  def get_release
    get_release! if @release.nil?
    @release
  end

  def get_release!
    @release = cli.releases(@repo).select { |r| r[:tag_name] == @release_tag }.first
  end

  def delete
    get_release
    begin
      @cli.delete_ref(@repo, "tags/#{@release_tag}")
    rescue
      print "Error when deleting remote tag"
    end
    delete_release
  end

  def delete_latest_release
    delete_release @cli.releases.first[:url]
  end

  def publish
    get_release
    @cli.update_release(@release[:url], draft: false) if @release
  end

  def delete_release(rel = @release)
    cli.delete_release(rel[:url])
  end
end

## Example:
# r = Releaser.new(ENV['GH_TOKEN'], 'v0.1.0-prerelease', 'Strauman/LaTeX-UiTStyles')
# r.push
# r.upload_asset "../uitstyle/release/uitstyle.cls"
# r.publish_release

## Debug copypaste to IRB:
# require 'octokit'
# require 'pp'
# token=ENV['GH_TOKEN']
# repo='Strauman/exercisebank'
# reltag='v0.1.0-prerelease'
# reltag='TEST'
# cli = Octokit::Client.new(access_token: token)
