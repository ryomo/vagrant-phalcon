## Summary
* Installs
    * Apache
        * SSL enabled.
    * MySQL
        * root password is `pass`.
    * phpMyAdmin
    * Phalcon
    * Composer
    * Phalcon DevTools

## How to use
### 1. git clone
```sh
git clone git@github.com:ryomo/vagrant_phalcon.git
cd vagrant_phalcon/
```

### 2. vagrant up
```sh
vagrant up
```

### 3. Create Phalcon project
```sh
vagrant ssh
```

```sh
cd /var/www/html/
sudo phalcon project myproject
```

### 4. Access

URL: [http://192.168.33.12/myproject/](http://192.168.33.12/myproject/)

  or [https://192.168.33.12/myproject/](https://192.168.33.12/myproject/)


## Commands
```sh
vagrant ssh
```

```sh
$ phalcon

Phalcon DevTools (1.3.4)

Available commands:~
```

```sh
$ composer
   ______
  / ____/___  ____ ___  ____  ____  ________  _____
 / /   / __ \/ __ `__ \/ __ \/ __ \/ ___/ _ \/ ___/
/ /___/ /_/ / / / / / / /_/ / /_/ (__  )  __/ /
\____/\____/_/ /_/ /_/ .___/\____/____/\___/_/
                    /_/
Composer version 1.0-dev (829199c0530ea131262c804924f921447c71d4e8) 2015-03-16 13:11:02

Usage:~
```
