namespace :db do
  desc "Populate database with job listings"
  task :populate => :environment do
    feed = JobListing.update_from_feed('https://www.jobsatosu.com/all_jobs.atom')
  end
end
