MOJO
====

Multiple OJs Operations (aka. mojo) is a bash script to create multiple Open Journal Systems (OJS) 
installations and "rule them all".

IMPORTANT: Right now (OJS 2.3.6) two minor changes are required for RESTFUL urls. More info about those changes: 
- http://pkp.sfu.ca/support/forum/viewtopic.php?f=8&t=7578&start=15#p32090
- http://pkp.sfu.ca/support/forum/viewtopic.php?f=8&t=7578&start=15#p32525

Installation
------------

1. Create a new user:  
```bash
    $ sudo useradd ojs -G sudo -m -U -d /home/ojs -p myPassword
```

2. Setup your apache:
```bash
    $ cd ~
    $ cp /home/ojs/source/templates/ojs /etc/apache/sites-avaliable
    $ vim /etc/apache/sites-avaliable/ojs;          # Replace magazine.localhost.net with your domain or GOTO 8.
    $ ln /etc/apache/sites-enabled/ojs /etc/apache/sites-avaliable/ojs
    $ /etc/init.d/apache restart  
```

3. Set your multisite structure
```bash
    $ sudo login ojs
    $ wget http://revistes.uab.cat/releases/multiojs-v0.3.tgz
    $ tar xvzf multiojs-v0.3.tgz
```

4. Setup your templates

 4.1. Be sure all *.base files (config, htacces...) points to the right URLs and include the right user/pwds.

 4.2. (optional) Dump the OJS DB of your preference (by default the script works with dumpBaseNew.sql and a few REDI_* tags)

5. Check magazine.sh variables to fit your needs:
```bash
    $ vim /home/ojs/scripts/mojo.sh
```

6. Create your first magazine
```bash
    $ cd scripts
    $ sudo ./mojo.sh createall myojs
    $ GOTO 6 :-P
```

7. More info about the script
```bash
    $ sudo ./mojo.sh help
```

8. (optional) Setup your network with a fake domain: Add "magazine.localhost.net" to your /etc/hosts
```bash
    $ vim /etc/hosts
```

Known bugs
----------

- Unable to login if your OJS code is not "patched".
- Permissions need to be reviewed (sudo not mandatory, avoid overwriting OJS ones...)
- Better parameter checking.

ToDo
----

- Request PKP a few minor changes in SessionManager class, bootstrap and config to suport multiOJS "out of the box".
- Ask for confirmation in potentially harmful operations.
- Backup&Restore commands: Self explainatory.
- Hot backup with mysqlhotdupm
- Info: With versions, paths, plugins and other OJS basic info.
- Update: To update OJS DB&code (based on /tools)
- CreateBase command: To generate a DB model.
- ReplaceVar command: To gloably change one OJS variable.
- ExecuteSQL command: To run a query against all magazines.
- PluginStatus command: To list/enable/disable plugin status.
- Password command: To periodiaclly change admin password globaly or set different DB usr/pwd for each magazine.
- Select command: To run comands against a set of magazines.
- Verbose "slow" operations.
- Migration from bash to PHP (as far as OJS is PHP).
- ...

Want to help?
-------------

Improve the code, test it or just give us feedback with your ideas.

Follow the history of this script in the following thread:

http://pkp.sfu.ca/support/forum/viewtopic.php?f=8&t=7578&p=31475#p31475

Contact
-------

- Author: Marc Bria Ramírez
- Mail: marc.bria[add]uab.es
