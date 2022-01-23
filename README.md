# desktop-compose
Isolated applications just by preparing single docker compose file.

## Depenedencies
- Linux or WSLg(Windows)
- [docker](https://docs.docker.com/get-docker/)
- [docker compose](https://docs.docker.com/compose/cli-command/#install-on-linux)

## Usage
Download compose file.
```bash:local
curl -o local-compose.yml https://raw.githubusercontent.com/ysuito/desktop-compose/master/local-compose.yml
```
Create app config by [Desktop Compose Generator]().
Add app config to compose file. 
Refer [app config sample]().

## Remote
Remote resource will be available by adding `remote-compose.yaml` to remote host.
Refer [detail]().

## Sync
In [Desktop Compose Generator](), select Sync. Add to `local-compose.yml` or `remote-compose.yml`.

## Limitation
- Remote sound is not available.
- Input method in WSLg is not available.
