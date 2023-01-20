# packwiz-serve

a minimal docker (or podman) container to serve packwiz modpacks anywhere :)

## how to use

all you need is one command:

```bash
docker run -d -p <your_desired_port>:8080 -v /path/to/your/modpack:/data getchoo/packwiz-serve
```

## troubleshooting

### permission denied errors

for users of a system with SELinux enabled, you maybe need to append `:z` to your volume mount options.

for example: `-v /path:/data:z`
