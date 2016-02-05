FROM #{FROM}

COPY entry.sh /usr/bin/entry.sh

STOPSIGNAL SIGTERM

ENTRYPOINT ["/usr/bin/entry.sh"]
