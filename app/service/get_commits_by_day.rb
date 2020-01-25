require 'uri'
require 'open-uri'

class GetCommitsByDay
  UrlTemplate = "https://api.github.com/repos/:owner/:repo/commits?path=:file"

  def call(owner:, repo:)
    commitDatesForGemfile = getCommitDatesForFile(owner: owner, repo: repo, file: "Gemfile")
    commitDatesForGemfileLock = getCommitDatesForFile(owner: owner, repo: repo, file: "Gemfile.lock")
    
      # ["January", "February", "March", "April", "May"], [ 2, 0, 4, 7, 3 ], [ 4, 6, 3, 9, 2 ]
    dates, countCommitGemfile, countCommitGemfileLock = groupByDateTwoCollections(commitDatesForGemfile, commitDatesForGemfileLock)
    return dates, countCommitGemfile, countCommitGemfileLock
  end

  private 

  def getCommitDatesForFile(owner:, repo:, file:)
    url = UrlTemplate.sub(':owner', owner).sub(':repo', repo).sub(':file', file)
    # Instead of deaserelazing whole response we just get one field
    open(url).read.split(',').select { |s| s.start_with?("\"date\":\"") }.uniq.map {|i| i.gsub(/[^\d,\-,\T]/, '')}.map { |x| Date.parse(x).strftime("%d-%m-%Y") }.reverse()
  end

  def groupByDateTwoCollections(commitDatesForGemfile, commitDatesForGemfileLock)
    dateByDay = (commitDatesForGemfile + commitDatesForGemfileLock).uniq.map { |s| Date.parse s }.sort().map { |s| s.strftime("%d-%m-%Y") }

    return dateByDay, countOffCommitsByday(commitDatesForGemfile, dateByDay), countOffCommitsByday(commitDatesForGemfileLock, dateByDay)
  end

  def countOffCommitsByday(commits, dateByDay)
    dateByDay.map do |date|
      commits.count(date)
    end
  end
end
