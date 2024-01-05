# ThrottleIfOver
Throttle CPU if temperature over x celcius


## Copy script

```
$ sudo cp ThrottleIfOver.sh /usr/bin/
$ sudo chown root:root /usr/bin/ThrottleIfOver.sh
$ sudo chmod 644 /usr/bin/ThrottleIfOver.sh    # make readable by root only
$ sudo chmod +x /usr/bin/ThrottleIfOver.sh
```

## Define the service

```
# /etc/systemd/system/ThrottleIfOver.service

[Unit]
Description=Throttle CPU if temperature over x
After=network.target

[Service]
ExecStart=/usr/bin/ThrottleIfOver.sh 60
Restart=always
User=root
Group=root

[Install]
WantedBy=default.target
```

## Test the script

```
$ sudo systemctl start ThrottleIfOver
$ sudo systemctl status ThrottleIfOver
```

## Start the script automatically

```
$ sudo systemctl enable ThrottleIfOver
```

