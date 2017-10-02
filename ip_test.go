package main

import (
	"fmt"
	"log"
	"testing"
)

func TestIp(t *testing.T) {
	if info, err := ipInfo("45.55.140.195"); err != nil {
		log.Fatal("error getting info: %s", err)
	} else {
		fmt.Printf("ip info is %s\n", info)
	}
}
