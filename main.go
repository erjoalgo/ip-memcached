package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"

	"github.com/bradfitz/gomemcache/memcache"
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

func ipInfo(ip string) (info IpInfo, err error) {
	// http://ip-api.com/json/208.80.152.201
	var body []byte
	if it, err := mc.Get(ip); err == nil {
		// log.Printf("cache hit for %s\n", ip)
		body = it.Value
	} else if resp, err := http.Get("http://ip-api.com/json/" + ip); err != nil {
		err = fmt.Errorf("falied to fetch ip info: %s", err)
	} else if body, err := ioutil.ReadAll(resp.Body); err != nil {
		err = fmt.Errorf("falied to read resp body: %s", err)
	} else {
		mc.Set(&memcache.Item{Key: ip, Value: body})
	}
	if json.Unmarshal(body, &info); err != nil {
		err = fmt.Errorf("falied to unmarshal ip info: %s", err)
	}
	return
}

var mc = memcache.New("localhost:11211")

func main() {
	// mc := memcache.New("10.0.0.1:11211", "10.0.0.2:11211", "10.0.0.3:11212")

	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		ip := scanner.Text()
		if info, err := ipInfo(ip); err != nil {
			log.Fatal("error getting info for %s: %s", ip, err)
		} else {
			fmt.Printf("%s\n", info)
		}
	}
}
