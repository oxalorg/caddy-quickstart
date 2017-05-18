echo "Downloading caddy..."
wget "https://caddyserver.com/download/linux/amd64?plugins=http.hugo" -O caddy

echo "Installing caddy..."
sudo mv caddy /usr/local/bin
sudo chown root:root /usr/local/bin/caddy
sudo chmod 755 /usr/local/bin/caddy


echo "Giving caddy permission to use port 80/443..."
sudo setcap 'cap_net_bind_service=+ep' /usr/local/bin/caddy


echo "Setting up www-data user for caddy..."
sudo groupadd -g 33 www-data
sudo useradd \
    -g www-data --no-user-group \
    --home-dir /var/www --no-create-home \
    --shell /usr/sbin/nologin \
    --system --uid 33 www-data


echo "Setting up configuration directories for caddy..."
sudo mkdir /etc/caddy
sudo chown -R root:www-data /etc/caddy
sudo mkdir /etc/ssl/caddy
sudo chown -R www-data:root /etc/ssl/caddy
sudo chmod 0770 /etc/ssl/caddy


echo "Sourcing default Caddyfile..."
sudo cp Caddyfile /etc/caddy/
sudo chown www-data:www-data /etc/caddy/Caddyfile
sudo chmod 444 /etc/caddy/Caddyfile


echo "Making directory to server webpages..."
sudo mkdir /var/www
sudo chown www-data:www-data /var/www
sudo chmod 555 /var/www


echo "Installing systemd caddy service..."
sudo cp caddy.service /etc/systemd/system/
sudo chown root:root /etc/systemd/system/caddy.service
sudo chmod 644 /etc/systemd/system/caddy.service
sudo systemctl daemon-reload
sudo systemctl enable caddy.service


echo "Done..."
