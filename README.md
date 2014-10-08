This repository is just a container for the repositories of the servers
making up a simple instance of a CartoDB service, and scripts to get the
instance up and running in a quick way:

 `./configure && make && ./start.sh`

To check everything is working as expected, run `make check`.

For more info about CartoDB: http://www.cartodb.com

# CONTRIBUTING

Pull requests for the wrapper can be sent on the github page:
 https://github.com/strk/easycartodb

Note that all the submodules point at my own fork of them.
This is to allow to more easily add configurationo changes to them
(configuration being the main value added by this project).

May you have particular configuration needs, the correct way to handle them
would be adding the appropriate configure switched in the relevant submodules
and then mirror them in the --help response of the top-level dir.

Pull request for submodule configuration changes should go upstream
when possible:
  https://github.com/CartoDB/Windshaft-cartodb
  https://github.com/CartoDB/CartoDB-SQL-API
  https://github.com/CartoDB/CartoDB

Or to the fork, if not still in sync with the upstream:
  https://github.com/strk/Windshaft-cartodb
  https://github.com/strk/CartoDB-SQL-API
  https://github.com/strk/CartoDB
