Dir["./models/**/*.rb"].each { |model|
  require model
}

Dir["./services/**/*.rb"].each { |service|
  require service
}

Dir["./lib/sinatra/**/*.rb"].each { |sinatra_lib|
  require sinatra_lib
}