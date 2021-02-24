
if Rails.env.test?
  Rake::Task['fixtures:csv_load:all'].execute

  ActiveRecord::Base.connection.tables.each do |t|
    ActiveRecord::Base.connection.reset_pk_sequence!(t)
  end
end 
