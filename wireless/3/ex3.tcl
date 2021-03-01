set ns [new Simulator]

set nf [open ex3.nam w]
$ns namtrace-all $nf
set tf [open ex3.tr w]
$ns trace-all $tf
set cwind [open win3.tr w]

$ns color 1 Blue
$ns color 2 Red

$ns rtproto DV

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns duplex-link $n0 $n1 1Mb 2ms DropTail
$ns duplex-link $n0 $n2 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 10ms DropTail
$ns duplex-link $n1 $n4 1Mb 2ms DropTail
$ns duplex-link $n2 $n3 1Mb 10ms DropTail
$ns duplex-link $n3 $n5 1Mb 10ms DropTail
$ns duplex-link $n3 $n4 1Mb 10ms DropTail
$ns duplex-link $n4 $n5 1Mb 3ms DropTail

# orientation kar lena

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set sink0 [new Agent/TCPSink]
$ns attach-agent $n5 $sink0
$ns connect $tcp0 $sink0
set ftp [new Application/FTP]
$ftp attach-agent $tcp0
$tcp0 set fid_ 1
$ns at 0.1 "$ftp start"

$ns rtmodel-at 1.0 down $n1 $n4
$ns rtmodel-at 3.0 up $n1 $n4

proc plotWindow {tcpSource file} {
global ns
set time 0.01
set now [$ns now]
set cwnd [$tcpSource set cwnd_]
puts $file "$now $cwnd"
$ns at [expr $now+$time] "plotWindow $tcpSource $file]"
}

$ns at 10.0 "finish"

proc finish {} {
global ns nf tf
$ns flush-trace
close $nf
close $tf
puts "running nam.."
exec nam ex3.nam & 
exec xgraph ex3.tr &
exit 0
}
$ns run
