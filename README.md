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

### 2. Change timezone and locale
*Default timezone is `Asia/Tokyo`*

To change timezone and locale, edit `provision.sh`'s `# timezone` section and `# locale` section.

### 3. vagrant up
```sh
vagrant up
```


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
