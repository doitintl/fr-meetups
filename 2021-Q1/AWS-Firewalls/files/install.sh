#!/usr/bin/env bash

amazon-linux-extras install nginx1
systemctl enable nginx
systemctl daemon-reload
systemctl start nginx
echo "<h1>DoiT - Meetup #2</h1><h2>AWS Firewalls</h2>" > /usr/share/nginx/html/index.html
