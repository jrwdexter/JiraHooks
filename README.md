JiraHooks
=========

## Summary

Jira Hooks is a simple set of files that operates with git-flow to provide developer-only comments to a JIRA instance.  

### Disclaimer

This is currently built for Nerdery purposes only, and the JIRA instance is setup as such.

## Setup

After cloning the repository, copy the files (git_hooks, .bat and .sh files) to the root directory of another repository.  After this is done, run either setup-git-hooks.bat or setup-git-hooks.sh.  You will be promped for your username and password, which will be base64 encoded into a file called 'jira-creds'.  After this, any branches that match:

[ANYTHING]/[TICKET]-###

A comment is then posted to [TICKET]-### on JIRA, and the commit message is then prefixed with [TICKET-###].
