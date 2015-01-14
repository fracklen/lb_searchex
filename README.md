# LbSearchex



`curl localhost:4000/api/dk/lease/stats/postal_districts`
```
curl -XGET "localhost:4000/api/dk/lease/locations/postal_district?postal_districts\[\]=2000"
curl -XPOST localhost:4000/api/dk/lease/locations/postal_district -d '{ "postal_districts":["2850"]}'
curl -XGET localhost:4000/api/dk/lease/locations/postal_district -d '{ "postal_districts":["2850"]}'
curl -XGET localhost:4000/api/dk/lease/locations/postal_district -d '{ "postal_districts":["2850"], "kinds":["warehouse"]}'
curl -v -XGET localhost:4000/api/dk/lease/locations/postal_district -d '{ "postal_districts":["1000","1500"], "kinds":["store","office"]}'
curl -XGET "localhost:4000/api/dk/lease/locations/postal_district?postal_districts\[\]=2850&kinds\[\]=warehouse"

curl -XGET "localhost:4000/api/dk/lease/locations/area_slug/sydjylland?kinds\[\]=warehouse"
curl -XGET "localhost:4000/api/dk/lease/locations/postal_district_slug/2600-glostrup?kinds\[\]=warehouse"
```

To start your new Phoenix application:

1. Install dependencies with `mix deps.get`
2. Start Phoenix endpoint with `mix phoenix.start`

Now you can visit `localhost:4000` from your browser.

## Test deploy
```
mix release
scp rel/lb_searchex/lb_searchex-0.0.1.tar.gz <user>@cm.local.lokalebasen.dk:/home/<user>/releases
scp .env <user>@cm.local.lokalebasen.dk:/home/<user>/releases
ssh ringling@cm.local.lokalebasen.dk
```
```
sudo docker run -i -p 4000:4000 -v /home/ringling/releases:/releases -t trenpixster/elixir /bin/bash
cd <HOME_DIR>/releases
tar -zxvf lb_searchex-0.0.1.tar.gz
bin/lb_searchex console
```
