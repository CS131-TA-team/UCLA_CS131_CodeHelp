# Go

## The tricky installation and Run
- [download](https://golang.org/)
- [addpath](https://github.com/golang/go/wiki/SettingGOPATH)
    * and likely to need ```export PATH=$PATH:/usr/local/go/bin/```
- option 1:
    * **go build ./XXX.go**
    * **./XXX**
- option 2:
    * have a repository named **XXX** under /usr/local/go/src/ and a **XXX.go** inside with main etc.
    * **go build XXX** from anywhere