# Varbase - Docker (Nginx, Mariadb)

Work in progress, do not use in production yet.

## Objective

Create a production ready varbase (Drupal) dev and deploy environment using Vanilla Docker without dependancies on Lando or other docker dev environments

## Specifications

Ports in use:

host tcp/8080 -> nginx tcp/80 (frontend webaccess: localhost:8080)
drupal tcp/9000 -> nginx tcp/9000 (fastcgi port)
drupal tcp/3306 -> mariadb tcp/3306 (database access port)

Volumes in use:

drupal:
      - ./drupal/modules:/var/www/html/modules
      - ./drupal/profiles:/var/www/html/profiles
      - ./drupal/sites:/var/www/html/sites
      - ./drupal/themes:/var/www/html/themes
      - drupal-site:/var/www/html/
mariadb:
      - ./mariadb:/var/lib/mysql
web-server: (nginx)
      - drupal-site:/var/www/html
      - ./nginx-conf:/etc/nginx/conf.d

## How to use

### For New site

First, setup your environmental variables.

Open `db.env` with your text editor and enter your desired database settings.
These will initialise your database and you will need these to connect drupal
later on.
(Note, not entirely familiar with Docker secrets so not sure how secure this is
yet)

Then, you will need to preseed the drupal/sites/ directory. Due the the
bind-mounted volumes, modules/ profiles/ sites/ and themes/ are empty by
default, which will be populated before install. This is documented on the
offical Docker Drupal image, except for our case, we need to seed all volumes
and not just the site directory.

Hence, you must build the varbase image and extract the sites dir into the host
machine.

Run

```{bash}
docker build -t varbase-base ./varbase-conf
mkdir -p docker/{sites,profiles,themes,modules}
for folder in "sites" "profiles" "themes" "modules"; do
    docker run --rm varbase tar -cC "/var/www/html/$folder" | tar -xC "./drupal/$folder"
done
```

Now you should be able to run the stack,

Run

`docker-compose -f dev-compose.yml up`

To pull in the required Docker services (containers) and deploy them on your
local machine.

Check the output for errors, if no errors occur, test if you can reach the site
on localhost:8080. If an error occurs, send an issue my way.

Now proceed with site setup as normal, the only exception is to ensure you connect the
mariadb database at an ip of `database`, at port `3306`. (database in the
varbase container is mapped to the ip of the mariadb container as an ease of use
feature in docker-compose)

### Importing site (Don't do this, yet to confirm any of this works)

First, setup the db.env file in your text editor. These will initialise the
mariadb database, and are settings you will use to connect drupal to the
database.

Then, copy over the sites/ themes/ profiles/ and modules/ from your old site
into the specified volume locations in the drupal/ folder.

(TODO) Place your sql dump in a certain folder, this will be imported on first deploy.

Change the file config to connect the drupal database to ip `database` at port
`3306`. (database in the varbase container is mapped to the ip of the mariadb
container as an ease of use feature in docker-compose)

Now run
`docker compose -f dev-compose.yml up` or `docker compose -f prod-compose.yml
up` to pull up your dev or production environment.

The site should be working.

## Updating

TODO

## TODO

- [x] Get base varbase site up on `docker-compose up`
- [x] Get base varbase site up with volumes mounted (Fix preseeding drupal/sites/\* issues)
- [] Test site importing
- [] Test database importing
- [] Identify proper upgrade procedure
