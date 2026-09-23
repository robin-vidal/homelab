# GoatCounter

Privacy-friendly web analytics, no cookies and no personal data tracking.

## Architecture

- **goatcounter** : official `arp242/goatcounter` image, `serve -automigrate` on `:8080`, TLS terminated by the gateway (`-tls http`, `-public-port 443`)
- **goatcounter-db** : CloudNativePG cluster, connection string read from the `goatcounter-db-app` secret and prefixed with `postgresql+`
- **PVC `goatcounter-data`** : GeoIP database and CSV exports (the hit data itself lives in PostgreSQL)

GoatCounter serves each site on its own vhost, so the site created below must
match the `HTTPRoute` hostname exactly.

## Bootstrap

The first site and its admin user are created once, by hand (they live in the
database, not in Git):

```sh
kubectl -n goatcounter exec -it deploy/goatcounter -- \
  goatcounter db create site \
    -vhost goatcounter.robin-vidal.com \
    -user.email robin.vidal.pro@gmail.com
```

The password is prompted interactively; passing `-user.password` instead would
leave it in the shell history and the API server audit log.

Then log in at <https://goatcounter.robin-vidal.com>.

## Usage

Add the counter snippet to a tracked site (e.g. `personal-site`):

```html
<script data-goatcounter="https://goatcounter.robin-vidal.com/count"
        async src="//goatcounter.robin-vidal.com/count.js"></script>
```

Outgoing email (password resets, weekly reports) is unconfigured: GoatCounter
prints mails to stderr, readable with `kubectl -n goatcounter logs deploy/goatcounter`.
Set `GOATCOUNTER_SMTP` to a relay URL to actually send them.
