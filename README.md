# LbSearchex

To start your new Phoenix application:

1. Install dependencies with `mix deps.get`
2. Start Phoenix endpoint with `mix phoenix.start`

Now you can visit `localhost:4000` from your browser.




## Test deploy

mix release
scp rel/lb_searchex/lb_searchex-0.0.1.tar.gz <user>@cm.local.lokalebasen.dk:/home/<user>
scp .env <user>@cm.local.lokalebasen.dk:/home/<user>/releases

sudo docker run -i -p 4000:4000 -v /releases:/releases -t trenpixster/elixir /bin/bash
cd <HOME_DIR>/releases
tar -zxvf lb_searchex-0.0.1.tar.gz
bin/lb_searchex console

curl cm.local.lokalebasen.dk:4000/api/dk/lease/stats/postal_districts
