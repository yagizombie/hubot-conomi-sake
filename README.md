# hubot-conomi-sake

A Hubot script that searches 'SAKE' infomation and responds the result.

See [`src/conomi-sake.coffee`](src/conomi-sake.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install git://github.com/yagizombie/hubot-conomi-sake.git --save`

Then add **hubot-conomi-sake** to your `external-scripts.json`:

```json
[
  "hubot-conomi-sake"
]
```

## Preparation

This script uses 'Sakenote Database API'. If you want to use this script,
you need to get the token of that API.

If you don't have the account of 'Sakenote Database API' yet, 
check the following and refer to it.

* http://blog.sakenote.com/2013/09/06/sakenote-api/

And then set the token to the environment variable 'CONOMI_SAKE_TOKEN'.

### Example of start-up script

```bash:hubot
#!/bin/sh

set -e

npm install
export PATH="node_modules/.bin:node_modules/hubot/node_modules/.bin:$PATH"
export EXPRESS_PORT=8089

export CONOMI_SAKE_TOKEN="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

exec node_modules/.bin/hubot "$@"
```

## Sample Interaction

```
user1>> hubot XXXXXってお酒
hubot>> 『XXXXX(xxxx)』
```
