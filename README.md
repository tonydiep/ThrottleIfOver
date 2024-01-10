# ThrottleIfOver
Throttle CPU if temperature over x celcius


## How to run script

Usage: ThrottleIfOver.sh TEMPERATURE
```
$ sudo ./ThrottleIfOver.sh 60
```

## How to run script automatically

### Copy script

```
$ sudo cp ThrottleIfOver.sh /usr/bin/
$ sudo chown root:root /usr/bin/ThrottleIfOver.sh
$ sudo chmod 644 /usr/bin/ThrottleIfOver.sh    # make readable by root only
$ sudo chmod +x /usr/bin/ThrottleIfOver.sh
```

### Create service to run script

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

### Start the service

```
$ sudo systemctl start ThrottleIfOver
$ sudo systemctl status ThrottleIfOver
```

### Start the service automatically

```
$ sudo systemctl enable ThrottleIfOver
```

