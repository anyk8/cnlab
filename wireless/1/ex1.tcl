set ns [new Simulator]

set nf [open ex1.nam w]
$ns namtrace-all $nf
set tf [open ex1.tr w]
$ns trace-all $tf

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n2 2Mb 2ms DropTail
$ns duplex-link $n1 $n2 2Mb 2ms DropTail
$ns duplex-link $n2 $n3 0.4Mb 10ms DropTail
$ns queue-limit $n0 $n2   5

# $ns duplex-link-op $n0 $n2 orient right-down
# $ns duplex-link-op $n1 $n2 orient right-up
# $ns duplex-link-op $n2 $n3 orient right

set udp0 [new Agent/UDP]
$ns attach-agent $n1 $udp0
set null [new Agent/Null]
$ns attach-agent $n3 $null
$ns connect $udp0 $null
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp0
$ns at 1.1 "$cbr start"

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set sink [new Agent/TCPSink]
$ns attach-agent $n3 $sink
$ns connect $tcp0 $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp0
$ns at 0.1 "$ftp start"

$ns at 10.0 "finish"

proc finish {} {
global ns nf tf
$ns flush-trace
close $nf
close $tf
puts "running nam..."
exec nam ex1.nam &
exit 0
}
$ns run
