package PiRelayControl

import (
	"fmt"
	"time"

	ping "github.com/sparrc/go-ping"
)

//Config for the server
type Config struct {
	PingAddress  string
	PingInterval int // Secodes
	PingTimeout  int
	PingFailure  float32
	PingBatch    int
}

//Start starts the server with the provided config
func Start(cfg *Config) {
	go cfg.startPingService()
}

func (c Config) startPingService() {
	for {
		time.Sleep(1 * time.Minute)
		go c.ping()
	}
}

func (c Config) ping() {
	var failure = 0
	var pass = 0
	// for index := 0; index < c.PingBatch; index++ {

	pinger, err := ping.NewPinger("www.google.com")
	if err != nil {
		panic(err)
	}
	pinger.Count = c.PingBatch
	pinger.Run() // blocks until finished
	pinger.Timeout = time.Duration(int64(c.PingTimeout) * int64(time.Millisecond))
	stats := pinger.Statistics()
	fmt.Println(stats)
	// p := fastping.NewPinger()
	// p.MaxRTT = time.Duration(int64(c.PingTimeout) * int64(time.Millisecond))
	// // ra, err := net.ResolveIPAddr("ip4:icmp", c.PingAddress)
	// // if err != nil {
	// // 	fmt.Println(err)
	// // 	failure++
	// // 	continue
	// // }
	// err := p.AddIP(c.PingAddress)
	// if err != nil {
	// 	failure++
	// 	fmt.Println(err)
	// 	continue
	// }
	// err = p.Run()
	// if err != nil {
	// 	failure++
	// 	fmt.Println(err)
	// 	continue
	// }
	// p.OnRecv = func(addr *net.IPAddr, rtt time.Duration) {
	// 	fmt.Printf("IP Addr: %s receive, RTT: %v\n", addr.String(), rtt)
	// }
	// p.OnIdle = func() {
	// 	fmt.Println("finish")
	// }
	// err = p.Run()
	// if err != nil {
	// 	fmt.Println(err)
	// 	failure++
	// 	continue
	// }
	pass++

	// }
	fmt.Println(failure, pass)
}
