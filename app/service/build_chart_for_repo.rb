require 'pi_charts'
require_relative "get_commits_by_day.rb"

class BuildChartForRepo
  def call(repo_url)
    owner, repo = getCredsFromRepoUrl(repo_url)
    date_period, gemfile_commits_count, gemfile_lock_commits_count = GetCommitsByDay.new().call(owner: owner, repo: repo)

    chart = PiCharts::Bar.new
    chart.add_labels(date_period)
    chart.add_dataset(label: "Gemfile commits count", data: gemfile_commits_count)
    chart.add_dataset(label: "Gemfile.lock commits count", data: gemfile_lock_commits_count)
    chart.stack
    chart.hover
    chart.responsive
    "<head>" + PiCharts::Utils.new.cdn + "</head>" + "<body>" + chart.html(width: 100) + "</body>"
  end

  private 

  def getCredsFromRepoUrl(repo_url)
    repo_url.to_s.split('/').last(2)
  end
end
