# GitTracker

[![Build Status](https://secure.travis-ci.org/stevenharman/git_tracker.png)](http://travis-ci.org/stevenharman/git_tracker)
[![Dependency Status](https://gemnasium.com/stevenharman/git_tracker.png)](https://gemnasium.com/stevenharman/git_tracker)
[![Code Climate](https://codeclimate.com/github/stevenharman/git_tracker.png)](https://codeclimate.com/github/stevenharman/git_tracker)

*GitTracker*, or *git-tracker*, is a Git hook that will scan your current
branch name looking for something it recognizes as a [Pivotal Tracker][pt]
story number. If it finds one, it will automagically add it, in the [special
format][pt-format], to your commit message.

## Installation

### 1) Install the `git-tracker` binary

You need to get the `git-tracker` binary onto your system, and then you need to
install the *git hook* into your local Git repository.

- via [Homebrew][homebrew] :beers: (preferred)

  ```bash
  $ brew install git-tracker
  ```

- via [RubyGems][rubygems] :pensive: (if you must)

  ```bash
  $ gem install git_tracker
  ```

### 2) Install the hook

You need to add the hook into each repository where you want to use it.

```bash
# from inside a local Git repository
# for example: /path/to/repo/
$ git tracker install
```

This will put the `prepare-commit-msg` hook in the `/path/to/repo/.git/hooks`
directory and make it executable.

**NOTE:** The hook needs to be installed just once for each repository in which
you will use it.

## Usage

With the hook installed in a repository, create branches being sure to include
the Pivotal Tracker story number in the branch name.

```bash
$ git checkout -b a_useful_and_helpful_name_8675309
```

When you commit, Git will fire the hook which will find the story number in the
branch name and prepare your commit message so that it includes the story number
in the [special Pivotal Tracker syntax][pt-format].

```bash
# on branch named `best_feature_ever-8675309`
$ git commit
```

Will result in a commit message something like: *(notice the two empty lines at
the top)*

```diff


[#8675309]
# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
# On branch best_feature_ever-8675309
# Changes to be committed:
#   (use "git reset HEAD <file>..." to unstage)
#
# new file:   feature.rb
#

```

You should then add a [useful and responsible commit message][tpope]. :heart:

### Passing commit messages via command line

If you pass a commit message on the command line the hook will still add the
story number, preceded by an empty line, to the end of your message.

```bash
# on branch named `best_feature_ever-8675309`
$ git commit -m'Look at this rad code, yo!'
```

Results in this commit message:

```
Look at this rad code, yo!

[#8675309]
```

However, if you include the story number in the Pivotal Tracker format within
your commit message, the hook will do nothing.

```bash
# on branch named `best_feature_ever-8675309`
$ git commit -m'[#8675309] Look at this rad code, yo!'
```

Results in this commit message:


```
[#8675309] Look at this rad code, yo!
```

### Keywords
You can use the custom keywords that Pivotal Tracker provides with the API.

The keywords are `fixed`, `completed`, `finished`, and `delivered` in square
brackets. You may also use different cases and forms of these verbs, such as
`Fix` or `FIXES`.

If you use those keywords in your commit message, the keyword will be prepended
to the story ID in the commit message.

For example:

```bash
# on branch named `bug/redis_connection_not_initializing_8675309`
$ git commit -am "Change the redis connection string [Fixes]"
```

Results in this commit message:

```bash
Change the redis connection string [Fixes]

[Fixes #8675309]
```

### Valid branch names

*GitTracker* allows you to include the story number any where in the branch
name, optionally prefixing it with a hash (`#`). Examples:

  - `best_feature_ever_#8675309`
  - `best-feature-ever-8675309`
  - `8675309_best_feature_ever`
  - `#8675309-best-feature-ever`
  - `your_name/8675309_best_feature_ever`
  - `your_name/#8675309_best_feature_ever`

## Contributing :octocat:

1. Fork it
2. Create your feature branch (`git checkout -b my_new_feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my_new_feature`)
5. Create new Pull Request


[pt]: https://www.pivotaltracker.com/
[pt-format]: https://www.pivotaltracker.com/help/api?version=v3#scm_post_commit_message_syntax
[tpope]: http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html
[homebrew]: http://mxcl.github.com/homebrew
[rubygems]: http://rubygems.org/gems/git_tracker
