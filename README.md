# docker-uGet

uGet can download videos from YouTube and a variety of different protocols including HTTP, HTTPS, FTP, BitTorrent, and Metalinks.

Project: <https://ugetdm.com/>

Base image used: jlesage/baseimage-gui:alpine-3.9

```shell
    docker run -d \
    --name=uGet \
    -p 5800:5800 \
    -p 5900:5900 \
    -v /docker/appdata/uget:/config:rw \
    -v /home/user/downloads:/downloads:rw \
    -e THEME=light \
    djaydev/uget
```

Where:

- `/docker/appdata/uget`: This is where the application stores its configuration, log and any files needing persistency.
- `Port 5800`: for WebGUI
- `Port 5900`: for VNC client connection
- `/home/user/downloads`: Directory for downloaded files.
- `THEME`: Theme chooser, either light or dark.

Browse to <http://your-host-ip:5800> to access the uGet GUI.

## Environment Variables

Some environment variables can be set to customize the behavior of the container and its application. The following list give more details about them available at <https://github.com/jlesage/docker-baseimage-gui#environment-variables>
