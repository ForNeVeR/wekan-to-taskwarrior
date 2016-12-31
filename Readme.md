wekan-to-taskwarrior
====================

That's a simple converter from [Wekan][wekan] to [Taskwarrior][taskwarrior].

Usage
-----

Export board data from Wekan to JSON, and then:

```console
$ ./Import.ps1 /path/to/wekan.json '+board-tag' '/path/to/task'
```

That will output the commands to create the necessary tasks in Taskwarrior.

[taskwarrior]: https://taskwarrior.org/
[wekan]: https://wekan.io/
