package main

import (
	"encoding/json"
	"fmt"
	"log"
	"testing"
)

func TestIp(t *testing.T) {
	skipCache = true
	if info, err := ipInfo("45.55.140.195"); err != nil {
		log.Fatal("error getting info: %s", err)
	} else {
		fmt.Printf("ip info is %s\n", info)
	}
}
func TestUnmarshal(t *testing.T) {
	var body = `{"as":"AS14061 Digital Ocean, Inc.",
"city":"Clifton",
"country":"United States",
"countryCode":"US",
"isp":"Digital Ocean",
"lat":40.8326,
"lon":-74.1307,
"org":"Digital Ocean",
"query":"45.55.140.195",
"region":"NJ",
"regionName":"New Jersey",
"status":"success",
"timezone":"America/New_York",
"zip":"07014"}`
	var info IpInfo
	json.Unmarshal([]byte(body), &info)
	if info.Country != "United States" {
		t.Fatal("unmarshal err")
	} else {
		fmt.Printf("country is %s\n", info.Country)
	}
}
