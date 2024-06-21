## Ruby/Rails version
*3.2.0/7.0.8.4*

## Database creation
```rails db:create```

```rails db:migrate```

## Populate new data in db
```rails db:seed```

## Run the test suite
```rspec```

## Run server
```rails s```

## API documentation
After starting server, use this api requests to match data

```curl -X GET http://localhost:3000/api/v1/jobs```

*returns lists all jobs (including deactivated ones)*
#

```curl -X GET http://localhost:3000/api/v1/applications_for_activated_jobs```

*returns all applications for all activated jobs*
