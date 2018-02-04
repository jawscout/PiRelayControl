package main

import (
	"fmt"
	"net/http"

	"github.com/jawscout/PiRelayControl"
)

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hi there, I love %s!", r.URL.Path[1:])
}

func main() {
	fmt.Println("Test")
	var cfg PiRelayControl.Config
	cfg.PingAddress = "8.8.8.8"
	cfg.PingFailure = .8
	cfg.PingInterval = 300000
	cfg.PingTimeout = 1
	cfg.PingBatch = 10
	PiRelayControl.Start(&cfg)
	http.HandleFunc("/", handler)
	http.ListenAndServe(":8080", nil)
}
