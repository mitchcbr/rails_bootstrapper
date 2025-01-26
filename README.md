# Welcome to rails_bootstrapper!

I've always found the process of standing up a new Rails application in a development container to be a bit awkward, so I created this tool to simplfy the process. The basic flow is:
- Clone this repo into a new folder.
- Create a new repository on Github.
- Update .env with your environment variables.
- Run docker compose up.


**Prerequisites:**
- [Install Docker Engine](https://docs.docker.com/engine/install/).
- Have a [Github](https://github.com) account.


**Usage:**
 1. Clone this repository.
	```
	git clone git@github.com:mitchcbr/rails_bootstrapper.git my_app
	cd my_app
	```
 2. Create a new repository in github.
 3. Copy .env.sample to .env.
	`cp .env.sample .env`
 4. Update the environment variable values.
    - *REPO_PATH:* This is where the new app will be pushed. It should match your new project's path on github.
    - *GITHUB_EMAIL:* This should match your Github email address.
    - *GITHUB_NAME:* Your first and last name on your Github account.
    - *DB_NAME:* This will be the name of the database that's created. The default should work fine.
    - *DB_USER:* This will be the username for the database. The default should work fine.
    - *DB_PASS:* This will be the password for DB_USER.
    - *RAILS_NEW_CMD:* If an existing application is not found by the entrypoint, a new app will be initialized with this command. If you make changes here, there are likely to be other changes needed in other files. For example, if you choose a different database, the docker-compose.yml will need to be updated so that it no longer provisions a Postgres database.
    - *BINDING:* The address the app will be served on. If this is not specified, Foreman will default to localhost, which isn't accessible from outside the container. It's recommended to set this to '0.0.0.0' while having also having a network firewall to protect your app from unauthorized activity.
    - *PORT:* The port the app will be served on. If this is not specified, it will default to 3000.
 5. Initialize and start the application.
`docker compose up`

	NOTE: If no 'Gemfile' or 'app' directory is found locally when the entrypoint is run, it will initialize a new Rails app and force push the changes to the remote repository, overwriting everything there! **Therefore, do not point the REPO_PATH variable at a repository containing anything you wish to keep.**

6. You should now be able to use your preferred IDE to make changes to your app, and changes can be pushed to the repository from locally or within the container.

7. Optional: Rename the services in the docker-compose.yml file, or they might conflict with other projects.
