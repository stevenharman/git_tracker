### dev
[full changelog](https://github.com/stevenharman/git_tracker/compare/v2.0.0...master)

### 2.0.0 / 2017-01-21
[full changelog](https://github.com/stevenharman/git_tracker/compare/v1.6.3...v2.0.0)

Breaking Changes

* Drop official support of EOL Rubies (e.g., 1.8.7, 1.9, and 2.0).
  Everything should still work fine, but that will change in the future.

Bug Fixes

* Only call `git-tracker` from the hook if the command exists.
  Fixes errors in GUI Git clients with a PATH that doesn't include the `git-tracker` install location.
  e.g., GitHub Desktop.
  [Issue #21](https://github.com/stevenharman/git_tracker/pull/21) ([D. Flaherty](https://github.com/flats))

### 1.6.3 / 2014-03-31
[full changelog](https://github.com/stevenharman/git_tracker/compare/v1.6.2...v1.6.3)

Bug Fixes

* Removew binstubs from packaged gem. Oops!

### 1.6.2 / 2014-03-26
[full changelog](https://github.com/stevenharman/git_tracker/compare/v1.6.1...v1.6.2)

Bug Fixes

* Restrict Tracker story numbers to be 6-10 digits long.
  [Issue #16](https://github.com/stevenharman/git_tracker/pull/16) ([Benjamin Darfler](https://github.com/bdarfler))

### 1.6.1 / 2013-08-12
[full changelog](https://github.com/stevenharman/git_tracker/compare/v1.6.0...v1.6.1)

Bug Fixes

* Be sure to use Ruby 1.8 hash syntax.

### 1.6.0 / 2013-08-12
[full changelog](https://github.com/stevenharman/git_tracker/compare/v1.5.1...v1.6.0)

Enhancements

* Add and default to `help` command.
  [Issue #15](https://github.com/stevenharman/git_tracker/issues/15)
* Deprecate `git-tracker install` in favor of `git-tracker init`.
  [Issue #13](https://github.com/stevenharman/git_tracker/issues/13)

### 1.5.1 / 2013-02-02
[full changelog](https://github.com/stevenharman/git_tracker/compare/v1.4.0...v1.5.1)

Enhancements

* Support installing via Homebrew: `brew install git-tracker`.
* Generate standalone binary via `rake standalone:build`.

### 1.4.0 / 2012-06-11
[full changelog](https://github.com/stevenharman/git_tracker/compare/v1.3.1...v1.4.0)

Enhancements

* Support Ruby 1.8.7.

### 1.3.1 / 2012-04-23
[full changelog](https://github.com/stevenharman/git_tracker/compare/v1.3.0...v1.3.1)

Bug fixes

* Bring back fourth Pivotal Tracker keyword, `delivered`.

### 1.3.0 / 2012-04-23
[full changelog](https://github.com/stevenharman/git_tracker/compare/v1.2.0...v1.3.0)

Enhancements

* Allow all three Pivotal Tracker keyword states: `fixed`, `completed`, and `finished`.

Bug fixes

* Pivotal Tracker keywords are case-insensitive.

### 1.2.0 / 2012-04-21
[full changelog](https://github.com/stevenharman/git_tracker/compare/v1.1.0...v1.2.0)

Enhancements

* Allow Pivotal Tracker keyword states: `Delivers` and `Fixes` ([KensoDev](https://github.com/KensoDev))

Bug fixes

* Exit with non-zero status code when a commit exists.
  [Issue #3](https://github.com/stevenharman/git_tracker/issues/3)
* Exit with non-zero status code with not in a Git repository.

### 1.1.0 / 2012-04-03
[full changelog](https://github.com/stevenharman/git_tracker/compare/v1.0.0...v1.1.0)

Enhancements

* The hash preceding the story number is optional.
  [CraigWilliams](https://github.com/CraigWilliams)

Bug fixes

* Fix case-sensitivity issue w/English library.
* Exit with non-zero status code with not in a Git repository.
  [Issue #1](https://github.com/stevenharman/git_tracker/issues/1)

### 1.0.0 / 2012-03-31
[full changelog](https://github.com/stevenharman/git_tracker/compare/v0.0.1...v1.0.0)

Enhancements

* Hook can install itself in a Git repository.

### 0.0.1 / 2012-03-23
[full changelog](https://github.com/stevenharman/git_tracker/compare/5fbbe061e721c1f86fdd5d78a4bfb4c61a0eaf5c...v0.0.1)

* Initial release
