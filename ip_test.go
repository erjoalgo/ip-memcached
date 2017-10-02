package main

import (
	"fmt"
	"testing"
)

func TestIp(t *testing.T) {
	info := ipInfo("45.55.140.195")
	fmt.Printf("ip info is %s\n", info)
}
