set ns [new Simulator]

set nf [open ex2.nam w]
$ns namtrace-all $nf
set tf [open ex2.tr w]
$ns trace-all $tf

set cwind [open win2.tr w]

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n2 5Mb 2ms DropTail
$ns duplex-link $n1 $n2 5Mb 2ms DropTail
$ns duplex-link $n2 $n3 1.5Mb 10ms DropTail

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set sink0 [new Agent/TCPSink]
$ns attach-agent $n3 $sink0
$ns connect $tcp0 $sink0
set ftp [new Application/FTP]
$ftp attach-agent $tcp0
$ns at 1.2 "$ftp start"

set tcp1 [new Agent/TCP]
$ns attach-agent $n1 $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $n0 $sink1
$ns connect $tcp1 $sink1
set telnet [new Application/Telnet]
$telnet attach-agent $tcp1
$ns at 1.5 "$telnet start"

proc plotWindow {tcpSource file} {
global ns
set time 0.01
set now [$ns now]
set cwnd [$tcpSource set cwnd_]
puts $file "$now $cwnd"
$ns at [expr $now+$time] "plotWindow $tcpSource $file"
}

$ns at 2.0 "plotWindow $tcp0 $cwind"
$ns at 5.5 "plotWindow $tcp1 $cwind"
$ns at 10.0 "finish"
proc finish {} {
global ns nf tf
$ns flush-trace
close $nf
close $tf
puts "running nam..."
puts "ftp packets.."
puts "telnet packets.."
exec nam ex2.nam &
exec xgraph ex2.tr &
exit 0
}
$ns run
