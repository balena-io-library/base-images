FROM #{FROM}

COPY entry.sh /usr/bin/entry.sh    

ENTRYPOINT ["/usr/bin/entry.sh"]
