## Summary
* Installs
    * Apache
        * SSL enabled.
    * MySQL
        * root password is `pass`.
    * phpMyAdmin
    * Phalcon
    * Zephir
    * Composer
    * Phalcon DevTools
    * Codeception

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


## Available commands in `vagrant ssh`

### phalcon
```sh
$ sudo phalcon

Phalcon DevTools (1.3.4)

Available commands:~
```

### zephir
```sh
$ zephir

 _____              __    _
/__  /  ___  ____  / /_  (_)____
  / /  / _ \/ __ \/ __ \/ / ___/
 / /__/  __/ /_/ / / / / / /
/____/\___/ .___/_/ /_/_/_/
         /_/

Zephir version 0.6.0a

Usage:~
```

### composer
```sh
$ sudo composer
   ______
  / ____/___  ____ ___  ____  ____  ________  _____
 / /   / __ \/ __ `__ \/ __ \/ __ \/ ___/ _ \/ ___/
/ /___/ /_/ / / / / / / /_/ / /_/ (__  )  __/ /
\____/\____/_/ /_/ /_/ .___/\____/____/\___/_/
                    /_/
Composer version 1.0-dev (829199c0530ea131262c804924f921447c71d4e8) 2015-03-16 13:11:02

Usage:~
```

### codecept
```sh
$ sudo codecept

Codeception version 2.0.11

Usage:~
```
