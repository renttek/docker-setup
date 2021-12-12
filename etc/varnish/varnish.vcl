vcl 4.0;

import std;

backend default {
    .host = "nginx-magento";
    .port = "80";
}

sub vcl_recv {
    if (req.http.X-Real-Ip) {
        set req.http.X-Forwarded-For = req.http.X-Real-Ip;
    }

    if (req.method == "PURGE") {
        if (!req.http.X-Magento-Tags-Pattern) {
            return (synth(400, "X-Magento-Tags-Pattern header required"));
        }
        ban("obj.http.X-Magento-Tags ~ " + req.http.X-Magento-Tags-Pattern);
        return (synth(200, "Purged"));
    }

    if (req.method != "GET" &&
        req.method != "HEAD" &&
        req.method != "PUT" &&
        req.method != "POST" &&
        req.method != "TRACE" &&
        req.method != "OPTIONS" &&
        req.method != "DELETE") {
          return (pipe);
    }

    if (req.method != "GET" && req.method != "HEAD") {
        return (pass);
    }

    if (req.url ~ "/checkout" || req.url ~ "/catalogsearch") {
        return (pass);
    }

    if (req.url ~ "^/(pub/)?(static)/.*\.(ico|css|js|jpg|jpeg|png|gif|tiff|bmp|mp3|ogg|svg|swf|woff|woff2|eot|ttf|otf)$") {
        return (pass);
    }

    set req.url = regsub(req.url, "^http[s]?://", "");
    std.collect(req.http.Cookie);

    if (req.http.Accept-Encoding) {
        if (req.url ~ "\.(jpg|jpeg|png|gif|gz|tgz|bz2|tbz|mp3|ogg|swf|flv)$") {
            unset req.http.Accept-Encoding;
        } elsif (req.http.Accept-Encoding ~ "gzip") {
            set req.http.Accept-Encoding = "gzip";
        } elsif (req.http.Accept-Encoding ~ "deflate" && req.http.user-agent !~ "MSIE") {
            set req.http.Accept-Encoding = "deflate";
        } else {
            unset req.http.Accept-Encoding;
        }
    }

    set req.url = regsuball(req.url,"\?gclid=[^&]+$","");
    set req.url = regsuball(req.url,"\?gclid=[^&]+&","?");
    set req.url = regsuball(req.url,"&gclid=[^&]+","");

    if (req.url ~ "^/(pub/)?(media|static)/.*\.(ico|css|js|jpg|jpeg|png|gif|tiff|bmp|mp3|ogg|svg|swf|woff|woff2|eot|ttf|otf)$") {
        unset req.http.Https;
        unset req.http.SSL-OFFLOADED;
        unset req.http.Cookie;
    }

    return (hash);
}

sub vcl_hash {
    if (req.http.cookie ~ "X-Magento-Vary=") {
        hash_data(regsub(req.http.cookie, "^.*?X-Magento-Vary=([^;]+);*.*$", "\1"));
    }

    if (req.http.host) {
        hash_data(req.http.host);
    } else {
        hash_data(server.ip);
    }

    if (req.http.SSL-OFFLOADED) {
        hash_data(req.http.SSL-OFFLOADED);
    }

}

sub vcl_backend_response {
    if (beresp.http.content-type ~ "text") {
        set beresp.do_esi = true;
    }

    if (bereq.url ~ "\.js$" || beresp.http.content-type ~ "text") {
        set beresp.do_gzip = true;
    }

    if (beresp.status != 200 && beresp.status != 404) {
        set beresp.ttl = 0s;
        set beresp.uncacheable = true;
        return (deliver);
    } elsif (beresp.http.Cache-Control ~ "private") {
        set beresp.uncacheable = true;
        set beresp.ttl = 86400s;
        return (deliver);
    }

    if (beresp.http.X-Magento-Debug) {
        set beresp.http.X-Magento-Cache-Control = beresp.http.Cache-Control;
    }

    if (beresp.ttl > 0s && (bereq.method == "GET" || bereq.method == "HEAD")) {
        unset beresp.http.set-cookie;
        if (bereq.url !~ "\.(ico|css|js|jpg|jpeg|png|gif|tiff|bmp|gz|tgz|bz2|tbz|mp3|ogg|svg|swf|woff|woff2|eot|ttf|otf)(\?|$)") {
            set beresp.http.Pragma = "no-cache";
            set beresp.http.Expires = "-1";
            set beresp.http.Cache-Control = "no-store, no-cache, must-revalidate, max-age=0";
            set beresp.grace = 1m;
        }
    }

   if (beresp.ttl <= 0s ||
        beresp.http.Surrogate-control ~ "no-store" ||
        (!beresp.http.Surrogate-Control && beresp.http.Vary == "*")) {
        set beresp.ttl = 120s;
        set beresp.uncacheable = true;
    }
    return (deliver);
}

sub vcl_deliver {
    if (resp.http.X-Magento-Debug) {
        if (resp.http.x-varnish ~ " ") {
            set resp.http.X-Magento-Cache-Debug = "HIT";
        } else {
            set resp.http.X-Magento-Cache-Debug = "MISS";
        }
    } else {
        unset resp.http.Age;

        unset resp.http.X-Magento-Debug;
        unset resp.http.X-Magento-Tags;
        unset resp.http.X-Powered-By;
        unset resp.http.Server;
        unset resp.http.X-Varnish;
        unset resp.http.Via;
        unset resp.http.Link;
    }

    set resp.http.X-Connection = "varnish";
}
