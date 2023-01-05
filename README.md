# dvmkv2ts-docker

A repository for creating a docker container to convert MKV Dolby Vision Files to TS/ISO in order to be compatible natively with TVs and players that don't support MKV Dolby Vision.

Tested on Oppo M9201.

![docker pulls](https://img.shields.io/docker/pulls/romancin/dvmkv2ts.svg) ![docker stars](https://img.shields.io/docker/stars/romancin/dvmkv2ts.svg) [![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=X2CT2SWQCP74U)

Latest versions:

![Docker Image Version (latest semver)](https://img.shields.io/docker/v/romancin/dvmkv2ts) ![docker size](https://img.shields.io/docker/image-size/romancin/dvmkv2ts)

You can invite me a beer if you want ;)

The container will execute a script that will convert the MKV files using two different approaches:

- MKV file with Dolby Vision profile 5 or 8: Converts the file to TS format directly.

- MKV file with Dolby Vision profile 7: Extract Dolby Vision Layers (BL and MEL/FEL) and converts them to BluRay ISO format.

Instructions:
- Map a directory where you have all the MKV files over `/convert` inside the container and execute the container to convert all the files.

Sample run command:

```bash
docker run -d --rm --name=dvmkv2ts \
-v /volume1/MKVFilesToConvert:/convert \
romancin/dvmkv2ts:latest
```

### Image TAGs available

| TAG       | Description                                  |
|-----------|----------------------------------------------|
|`latest`| Latest available version of **dvmkv2ts** |
|`develop`| Used for develop purposes **dvmkv2ts** |
|`vX.X.X` | Points directly to one of the **dvmkv2ts** versions available|

### Data Volumes

The following table describes data volumes used by the container.  The mappings
are set via the `-v` parameter.  Each mapping is specified with the following
format: `<HOST_DIR>:<CONTAINER_DIR>[:PERMISSIONS]`.

| Container path  | Permissions | Description |
|-----------------|-------------|-------------|
|`/convert`| rw | This is where the container will take the MKV files. **IMPORTANT**: All the files in this directory will be converted. |

## Support or Contact

Having troubles with the container or have questions?  Please
[create a new issue].
