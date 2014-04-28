MOJO
====

Multiple OJs Operations (aka. mojo) is a bash script to create multiple Open Journal Systems (OJS) 
installations and "rule them all".

More information about this script:
http://pkp.sfu.ca/wiki/index.php?title=Installation:_Multiple_OJS_%26_mOJO

<strong>IMPORTANT:</strong> Since OJS 2.3.6 two minor changes are required for RESTFUL urls. 
You can read more info about those patches: 
- http://pkp.sfu.ca/support/forum/viewtopic.php?f=8&t=7578&start=15#p32090
- http://pkp.sfu.ca/support/forum/viewtopic.php?f=8&t=7578&start=15#p32525
(This is not required any more in OJS 2.3.8)


Installation
------------

 1. Create a new "ojs" user:
 ```bash
    $ sudo useradd ojs -G sudo -m -U -d /home/ojs -p myPassword
    $ sudo usermod -s /bin/bash ojs
 ```
 <strong>Note:</strong> The user name could be other than "ojs" but then you will need to review the script to fit you username.

 2. Set your multisite structure
 ```bash
    $ sudo login ojs
    $ git clone https://github.com/marcbria/mojo.git
    $ mv mojo/* .
    $ mv mojo/.* .
    $ mkdir webdata htaccess
    $ rmdir mojo
 ```

 3. Setup your Apache: (instructions for Debian-like distros)
 ```bash
    $ exit
    $ sudo -s
    $ cp /home/ojs/source/templates/virtualHost.base /etc/apache2/sites-available/ojs
    $ vim /etc/apache2/sites-available/ojs;          # Replace magazine.localhost.net with your domain or GOTO 8.
    $ ln /etc/apache2/sites-enabled/ojs /etc/apache2/sites-available/ojs
    $ chown root:www-data /etc/apache/sites-available/ojs
    $ /etc/init.d/apache restart
 ```

 4. Setup your templates. See source/templates

   4.1. Files with extension .base will be used as templates to generate the config files for every OJS generated by MOJO. Be sure all *.base files (config, htacces...) points to the right URLs and include the right user/pwds. MOJO will work with multiple databases, each one for each ojs, but with unique user/password.

   4.2. (optional) Dump the OJS DB of your preference (by default the script works with dumpBaseNew.sql and a few MOJO_* tags). This dump will be used as base to generate each new site. 
 
 <strong>IMPORTANT:</strong> Replace the harcoded "http://magazine.localhost.net" with your domainname or, if you create your own database dump, be sure you replace the magazine's tag with MOJO_JOURNAL_TAG token (more information about dumps and mojo variables at script/config.mojo)

 5. Check config.mojo variables to fit your needs:
 ```bash
    $ vim /home/ojs/scripts/mojo.sh
 ```

 6. Add mOJO to your /usr/bin
 ```bash
    $ ln -s /home/ojs/scripts/mojo.sh /usr/bin/mojo
 ```

 7. Login to your new mojo environement and test mOJO:
 ```bash
    $ sudo login ojs
    $ mojo
 ```
 If you get mojo's help it means the script is working.

 8. Create your first magazine
 ```bash
    $ mojo create all myojs
 ```
 GOTO Step 8 :-P

 9. (optional) Setup your network with a fake domain: Add "magazine.localhost.net" to your /etc/hosts
 ```bash
    $ sudo vim /etc/hosts
 ```

The default user/pwds of MOJO are:
- mojo / setMyPass
- admin / setMyAdminPass (OJS user)
- editor / setMyEditorPass (OJS user) 

Please, change ASAP to avoid security issues and fit your needs.


Common issues
-------------
- Are permissions are not correcly set?
 - This usually fixes the issues, but you need to understand what you are doing (and review to fit to your needs and distro):
  ```bash
    $ cd /home/ojs
    $ chown ojs:www-data 
    $ chmod 774
  ```

- "Invalid command 'RewriteEngine', perhaps misspelled or defined by a module not included in the server configuration"
 - Probably your Apache don't include the "modrewrite" module.
  ```bash
    $ sudo a2enmod rewrite
    $ service apache2 restart
  ```

- "Database connection failed!"
 - Probably your script/mojo.config file don't include the right MySQL root password.


Known bugs
----------

- Unable to login if your OJS code is not "patched" (fixed if OJS > 2.3.8)
- Permissions need to be reviewed (sudo not mandatory, avoid overwriting OJS ones...)
- Better parameter checking.

ToDo
----

- [x] Asks for mysql password (instead of hardcoding).
- [x] Backup&Restore commands: Self explainatory.
- [x] CreateDB command: To generate a DB model.
- [x] Speedup "htaccess" command.
- [x] Request PKP a few minor changes in SessionManager class, bootstrap and config to suport multiOJS "out of the box".
- [x] Ask for confirmation in potentially harmful operations.
- [x] "Interactive mode": Ask for params when is required.
- [ ] "File based mode": Extracts arguments from a config file. 
- [ ] Hot backup with mysqlhotdump (under discussion)
- [ ] Info: With versions, paths, plugins and other OJS basic info.
- [ ] Update: To update OJS DB&code (based on /tools)
- [ ] ReplaceVar command: To gloably change one OJS variable.
- [x] ExecuteSQL command: To run a query against all magazines.
- [ ] PluginStatus command: To list/enable/disable plugin status.
- [x] Password command: To periodiaclly change admin password globaly or set different DB usr/pwd for each magazine.
- [x] Select command: To run comands against a set of magazines.
- [ ] Give feedback (Verbose, progressbar...) for "slow" operations.
- [ ] Silent option for secondary commands.
- [ ] Migration from bash to PHP as far as OJS is PHP (under discussion).
- [ ] ...

Want to help?
-------------

Improve the code, test it or just give us feedback with your ideas.

Follow the history of this script in the following thread:

http://pkp.sfu.ca/support/forum/viewtopic.php?f=8&t=7578&p=31475#p31475

More information:

http://pkp.sfu.ca/wiki/index.php?title=Installation:_Multiple_OJS_%26_mOJO

Thanks to [PKP](http://pkp.sfu.ca) and [Projecte Ictineo](http://projecteictineo.com) for the feedback, support and work to keep this project up. 

Contact
-------

- Author: Marc Bria Ramírez
- Mail: marc.bria[add]uab.es
