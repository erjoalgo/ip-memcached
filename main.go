package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
)

var example = `
{
  "status": "success",
  "country": "United States",
  "countryCode": "US",
  "region": "CA",
  "regionName": "California",
  "city": "San Francisco",
  "zip": "94105",
  "lat": "37.7898",
  "lon": "-122.3942",
  "timezone": "America\/Los_Angeles",
  "isp": "Wikimedia Foundation",
  "org": "Wikimedia Foundation",
  "as": "AS14907 Wikimedia US network",
  "query": "208.80.152.201"
}`

type IpInfo struct {
	Status      string // "success",
	Country     string // "United States",
	Countrycode string // "US",
	Region      string // "CA",
	RegionName  string // "California",
	City        string // "San Francisco",
	Zip         string // "94105",
	Lat         string // "37.7898",
	Lon         string // "-122.3942",
	Timezone    string // "America\/Los_Angeles",
	Isp         string // "Wikimedia Foundation",
	Org         string // "Wikimedia Foundation",
	As          string // "AS14907 Wikimedia US network",
	Query       string // "208.80.152.201"
}

func ipInfo(ip string) (info IpInfo) {
	// http://ip-api.com/json/208.80.152.201
	if resp, err := http.Get("http://ip-api.com/json/" + ip); err != nil {
		log.Fatal("falied to fetch ip info: %s %s", ip, err)
	} else if body, err := ioutil.ReadAll(resp.Body); err != nil {
		log.Fatal("falied to read http response ip info: %s %s", ip, err)
	} else {
		if json.Unmarshal(body, &info); err != nil {
			log.Fatal("falied to unmarshal ip info: %s %s", ip, err)
		} else {
			return
		}
	}
	return
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		ip := scanner.Text()
		info := ipInfo(ip)
		fmt.Printf("%s\n", info)
	}
}
