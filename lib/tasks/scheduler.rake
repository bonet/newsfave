desc "This task is called by the Heroku scheduler add-on"
task :delete_old_sessions => :environment do
  puts "Deleting old sessions ..."
  connection = ActiveRecord::Base.connection()
  connection.execute("DELETE FROM sessions WHERE updated_at < '#{(Time.now.utc - (60 * 60 * 2)).to_s}'")
  puts "done."
end
