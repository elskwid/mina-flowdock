# mina-flowdock

* [Homepage](https://github.com/elskwid/mina-flowdock#readme)
* [Issues](https://github.com/elskwid/mina-flowdock/issues)
* [Documentation](http://rubydoc.info/gems/mina-flowdock/frames)
* [Email](mailto:don at elskwid.net)

## Description

Mina plugin to add [Flowdock](http://flowdock.com) deployment notifications.

`mina-flowdock` pushes deployment notifications to Flowdock team inboxes using
the Flowdock [API](https://github.com/flowdock/flowdock-api/).

## Features

### Notify multiple flows

Add multiple Flowdock API tokens to send notifications to multiple flows.

### Default tags

Notifications are tagged with `#deploy` and the stage (deploy env). More
tags can be added. See (Settings).

### Supports notifications for commit/branch

The Mina git module supports deployment using a specific commit or branch.
The option used is detected and included in the notifications.

### Verifies the commit/branch

The bare checkout on the server is used to find the sha for the commit/branch
being deployed which is then returned in the notification. An error is raised
if it can't be retrieved.

### Respects Mina simulate option

The notifications are not sent if mina is run with the `--simulate` option.

### Uses git for user name and email

The `Ruby/Git` library is used to access the git config for the local repository
and send the notification from the user configured there.

### Configurable settings

Most of the settings are easily overridden. See (Settings).

## Comparison to flowdock/capistrano

There are some differences between the Mina notifications and those sent
from [flowdock/capistrano](https://github.com/flowdock/flowdock-api/blob/master/lib/flowdock/capistrano.rb)
because of the assumptions made by each deployment library.

The capistrano notifications will list deployed commits when possible. Cap
has access to a full git checkout and with that the currently deployed branch.
Mina uses a bare repository and so the branch or commit for the current
deploy is not known. `mina-flowdock` just sends a simple notification that a
branch or commit has been deployed to a specific stage.

## Usage

```ruby
# In your deploy tasks...

require 'mina/flowdock'

# required settings
set :flowdock_project_name, "my_project"
set :flowdock_api_token, ["firstflowapitoken", "secondflowapitoken"]
set :flowdock_deploy_env, stage

# optional settings
set :flowdock_deploy_tags, ["my_tag1", "my_tag2"]
```

Then run `mina deploy ...` as usual. Requiring `mina/flowdock` extends the
file with some helper methods, includes the Flowdock notification task
(`flowdock:notify`), and uses `mina-hooks` to queue the notifications to
run after the deployment.

## Settings

### Required

The `flowdock:notify` task will exit with an error if any of the required
settings are missing.

#### `flowdock_project_name`

The name of the project being deployed. Used in the subject of the notfications.

**Default:** not set

#### `flowdock_api_token`

List of one or more api tokens for the flows that should receive notifications.
Used to authorize inbox notifications.

**Default:** not set

#### `flowdock_deploy_env`

Deployment environment for this deploy. (i.e. production, staging, qa). Used
in the default notification message.

**Default:** not set

### Other / Optional

These settings aren't required to be set in your deployment scripts or may
be otherwise configurable.

#### `flowdock_deploy_tags`

List of tags used to tag the team inbox notification. Always includes both
the `deploy` and deploy env name as tags.

**Default:** ["deploy", flowdock_deploy_env]

#### `flowdock_source`

Source for Flowdock notifications.

**Default:** "Mina deployment"

#### `flowdock_from_name`

Name of the person sending the notifications. Used as the user link in
notifications.

**Default:** "user.name" retrieved from git config for the local repository.

#### `flowdock_from_email`

Email of the person sending the notifications. Used as the user link in
notificiations.

**Default:** "user.email" retrieved from git config for the local repository.

#### `flowdock_message_subject`

ERB string used as the notification subject.

**Default:** "<%= flowdock_project_name %> deployed to #<%= flowdock_deploy_env %>"

Example: MyProject deployed to staging.

#### `flowdock_message`

ERB string used as the notification body.

**Default:** "<%= flowdock_deploy_type %> <%= flowdock_deploy_ref %> (<%= flowdock_deploy_sha %>) was deployed to <%= flowdock_deploy_env %>."

Example: Branch feature-branch (git-sha) was deployed to staging.

### Internal

These can't be overridden. Well, not easily overridden.

#### `flowdock_deploy_type`

One of "Branch" or "Commit" depending on the option passed to mina.

#### `flowdock_deploy_ref`

Either the branch name or the commit sha passed ot mina.

#### `flowdock_deploy_sha`

The git sha retrieved from the server after deployment. Uses the
`flowdock_deploy_ref` to get the sha and return it for use in notifications.

## Requirements

  * [flowdock](https://github.com/flowdock/flowdock-api/)
  * [git](https://github.com/schacon/ruby-git)
  * [mina](https://github.com/nadarei/mina)
  * [mina-hooks](https://github.com/elskwid/mina-hooks)

## Install

    $ gem install mina-flowdock

## Copyright

Copyright (c) 2013 Don Morrison

See {file:LICENSE.txt} for details.
