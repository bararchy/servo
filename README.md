# servo

Full Fledged mail server inspired by https://github.com/tijn/devmail 

## Installation

Right now you can play with it by building the main bin:  
```bash
crystal build src/servo.cr
sudo ./servo # This is using port 25 by default right now (which means root privs)
```


## Development

- [ ] Add more protocols  
- [ ] Add databse to store mails, users, etc.. (mariaDB ? maybe PG ? )  
- [ ] Add support for openssl\STARTLS  


## Contributing

1. Fork it ( https://github.com/bararchy/servo/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [bararchy](https://github.com/bararchy) bararchy - creator, maintainer
