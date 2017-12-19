
## Local Setup

The proper way to develop Behat tests locally is to run a certain setup that differs from express.local or the Express Starter kit. The reason the setup differs for creating tests is that connecting to a browser emulating server is a huge PITA when you are using VMs. 

Specifically, when a JS test opens a window and simulates how a user would navigate a site, you aren't able to see what is going on. Having the VM connect to a browser emulating server on your local machine could mitigate this issue; however, if you have to run any PHP, you won't be able to do that since the web application isn't connected to the emualtor server. 

Rather than fiddle with a brittle local setup using VMs connecting to your local machine, it is easiest and most straight-forward to setup your own environment. 

You will need:
- PHP 7 - [Homebrew works well for this step](https://github.com/Homebrew/homebrew-php).
- MySQL - [Homebrew can be used also here](https://gist.github.com/nrollr/3f57fc15ded7dddddcc4e82fe137b58e).
- Composer - Once PHP is installed, [you can install Composer](https://getcomposer.org/doc/00-intro.md#installation-linux-unix-osx) locally or globally.
- Drush - Once Composer is installed, `composer global require "drush/drush:8.*"` to install Drush globally. 

You can check the versions of what you have locally, but for this tutorial the versions are as follows:
- PHP `7.1.10`
- MySQL `Server version: 5.7.19 Homebrew`
- Composer `1.5.2`
- Drush `8.1.12`

## Running Tests

You can now install an Express site however you want to using your MySQL setup for the server. The [Express Starter](https://github.com/CuBoulder/express-starter) kit can build you out a skeleton site that you can run `drush si` from after changing the database settings in "sites/default/settings.php".

You will need to install Behat's dependencies as well as adding some configuration changes to `behat.local.yml` in order to run tests.

```bash
cd site-path/profiles/express/tests/behat
composer install
```

```yaml
  extensions:
    DMore\ChromeExtension\Behat\ServiceContainer\ChromeExtension: ~
    Behat\MinkExtension:
        browser_name: chrome
        base_url: http://127.0.0.1:8888
        sessions:
          default:
            chrome:
              api_url: "http://0.0.0.0:9222"
        # Change to your path.      
        files_path: "/Users/your-name/Sites/your-path/profiles/express/tests/behat/assets/"
    Drupal\DrupalExtension:
      blackbox: ~
      api_driver: 'drupal'
      drupal:
        # Change to your path.
        drupal_root: "/Users/your-name/Sites/your-path"
      subcontexts:
        # Change to your path.
        paths:
          - "/Users/your-name/Sites/your-path/profiles/express/tests/behat"
```

