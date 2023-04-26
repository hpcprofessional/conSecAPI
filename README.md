# conSecAPI
A quick-n-dirty example of using the [Tenable Container Security API](https://developer.tenable.com/reference/cs-v2-images)

Also includes a couple of scripts to download the Tenable Conatiner scanner, one to onboard a registry and the last to import an image (perhaps as part of CI/CD)

## For Windows users

The bash scripts run in Ubuntu Windows Subsystem for Linux 2. Here are some notes:

* For best results, start a WSL session and then clone the repo, edit the files, etc. 

* If you clone this repository using Windows outside of WSL, it is likely you will have issues with line endings. If you see errors like this running the script, this is your problem:

```
./scannerImportImage.sh: line 3: $'\r': command not found
./scannerImportImage.sh: line 8: $'\r': command not found
./scannerImportImage.sh: line 9: $'\r': command not found
./scannerImportImage.sh: line 12: $'\r': command not found
./scannerImportImage.sh: line 18: $'\r': command not found
./scannerImportImage.sh: line 21: $'\r': command not found
./scannerImportImage.sh: line 30: $'\r': command not found
./scannerImportImage.sh: line 36: $'\r': command not found
./scannerImportImage.sh: line 39: $'\r': command not found
./scannerImportImage.sh: line 42: $'\r': command not found
./scannerImportImage.sh: line 47: $'\r': command not found
./scannerImportImage.sh: line 111: syntax error: unexpected end of file
```
This can be fixed by, within WSL, navigating to the scripts directory and running the command

```
git checkout *
```
Note that this will overwrite any changes you have made to the file(s).
