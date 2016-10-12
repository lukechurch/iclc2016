# Getting started with Molly

The following has been tested only on macOS, but the process should be similar on Linux as well.


## Install Dart

Follow the instructions on [www.dartlang.org](https://www.dartlang.org/install).

To test that is has installed successfully, run ```dart --version``` from the command line.


## Install Node.js and npm

Follow the instructions on [nodejs.org](https://nodejs.org/en/download/).

To test that is has installed successfully, run ```node --version``` and ```npm --version``` from the command line.


## Install the dependencies for each server

Run install_dependencies.sh from the root directory of the repo (i.e. iclc2016/):

``` bash install_dependencies.sh```


## Start (all) the servers

Each server below must be started in a different terminal window. All commands are relative to the root directory of the repo (i.e. iclc2016/)

### Start the Vis server

```dart vis-server/bin/main.dart```

### Start the parser server

```cd parser && node server-demo.js```

### Start the execution server

```dart runner/bin/server_exec.dart```

### Start the Vis UI

```cd vis && pub serve --port=8081```

### Start the editor UI

```cd web-editor && pub serve --port=8080```

## Start coding


Go to [localhost:8080](http://localhost:8080) to write code in Molly, and see the visualisation created at [localhost:8081](http://localhost:8081/test.html).