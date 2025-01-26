# Welcome to rails_bootstrapper!

I've always found the process of standing up a new containerized Rails application for development to be a bit awkward, so I created this tool to simplfy the process. The basic flow is:
- Create a new repository on Github.
- Clone this repo into a new folder.
- Update .env with your environment variables.
- Run docker compose up.

The entrypoint will set your upstream origin, initialize the Rails app, commit and push the changes to your repository, and start the containerized application with bin/dev. By default, the app will use a Postgres backend (also provisioned by docker compose) and Tailwind CSS.

___

**Prerequisites**
- [Install Docker Engine](https://docs.docker.com/engine/install/).
- Have a [Github](https://github.com) account.

___

**Usage**
 1. Create a new repository in github.
 2. Clone this repository. It's recommended to adjust the 'my_app' folder name to match your repository name.
	`git clone git@github.com:mitchcbr/rails_bootstrapper.git my_app && cd my_app`
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

___

**A Word on Mounted Volumes**
- Mounting your ssh key to the container allows you to interact with the Github repo directly from the container.
- Mounting the whole local project folder allows you to also push changes from your local console.
- Database files are stored in pgsql and ignored by .gitignore.

7. You should now be able to use your preferred IDE to make changes to your app, and changes can be pushed to the repository from locally or within the container.

8. Optional: Rename the services in the docker-compose.yml file, or they might conflict with other projects.
