# ClientsSearch

This is a minimalist command-line application built with Ruby that allows you to search through client data and find duplicate records.

## Setup

- run `bundle install` to setup required gems 


## Running the Command-line application

To run the application, use the following command from the project root directory:

```
bin/clients_search <command> [field] [query] [json_file_path]
```

Available commands:
 - `search <field> <query>`: Search for clients by a specific field
 - `find_duplicates [field]`: Find clients with duplicate values in the specified field (defaults to full_name if not specified)


The `json_file_path` argument is optional. If not provided, the application will use the default JSON file located at `spec/data/clients.json`.


Examples:
```
bin/clients_search search full_name John
bin/clients_search search full_name John YOUR_COSTOM_JSON_FILE
bin/clients_search search email alex.johnson@hotmail.com


bin/clients_search find_duplicates
bin/clients_search find_duplicates email
bin/clients_search find_duplicates email YOUR_COSTOM_JSON_FILE
bin/clients_search find_duplicates full_name
```


## Running the Web application


we use sinatra for web application. to start server, run
```
ruby app.rb
```
- `localhost:3000/query` for query
examples:
```
localhost:3000/query?q=John  # query on default field `full_name`
localhost:3000/query?q=John&field=email  # query on field `email`
```

- `localhost:3000/find_duplicates` for find_duplicates
examples:
```
localhost:3000/find_duplicates  # find_duplicates on default field `email`
localhost:3000/find_duplicates?field=full_name  # find_duplicates on field `full_name`
```

## Assumptions

- default json file is `spec/data/clients.json`

- The search functionality is case-insensitive and matches partial field values.

- searchable fields are limited to data structure (email, full_name)

-  The  `find_duplicates` command defaults to searching for duplicate on `email` field

- If not existed or invalid json file is passed in the args, exception will be raised.

- The main logic is extracted to `Repository` class so it can be re-used in other interface beside CLI like a web application

   

## Testing

This prject use rspec, running test please run

```
bundle exec rspec
```

tests includes unit tests and an integration test 

## Linter

- run `standardrb` for ruby linter

