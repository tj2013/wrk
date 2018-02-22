./wrk -t10 -c1000 -d5m -s test.lua --timeout 60000  url

1)

10 thread, 1000 total connections

Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    20.00s    14.62s    1.17m    90.91%
    Req/Sec     0.57      2.18    10.00     95.24%
  22 requests in 5.01m, 1.42GB read
  Errors: connect 0, read 2781, write 0, timeout 0, http parse 8809, http incomplete 1448
Requests/sec:      0.07


2)

10 thread, 100 total connections

Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    15.23s     2.12s   20.99s    63.16%
    Req/Sec     2.52      3.68    29.00     85.95%
  1908 requests in 5.00m, 2.04GB read
Requests/sec:      6.36

No error

3)

10 thread, 300 total connections

Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    30.75s     7.22s   41.13s    76.10%
    Req/Sec     4.21      4.92    40.00     80.99%
  2837 requests in 5.00m, 3.04GB read
Requests/sec:      9.45

although no error is found, the latency is much higher

4)

change CPU from 2 to 1, memory from 4096 to 1024

Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     7.61s    10.57s   41.99s    81.40%
    Req/Sec   136.43    129.26   494.00     57.13%
  78501 requests in 5.00m, 2.64GB read
  Errors: connect 0, read 0, write 0, timeout 0, http parse 4, http incomplete 0
  Non-2xx or 3xx responses: 76080
Requests/sec:    261.59 

actually about 2421 request in 5.00m, sometimes memory usage to 700M, possibly cause this issue

Run the test twice and similar results

5)

Keep CPU as 1, and change memory to 4096

Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    30.41s     7.19s    1.21m    73.24%
    Req/Sec     3.89      4.91    40.00     77.96%
  2880 requests in 5.00m, 3.09GB read
  Errors: connect 0, read 0, write 0, timeout 0, http parse 0, http incomplete 1
Requests/sec:      9.60

Max memory is 1.2G so 4096 is enough

So in case of 300 connections, 4096 memory and 1 CPU is good, but latency is too long

6)

Deploy 3 instance

  10 threads and 300 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    30.32s     6.96s   43.32s    69.07%
    Req/Sec     3.65      4.30    30.00     79.17%
  2897 requests in 5.00m, 3.10GB read
Requests/sec:      9.65

No better than 1 instance


===========================
./wrk -t1 -c1 -d5m -s test1.lua --timeout 60000  urlx
thread 1 made 28 requests and got 26 responses, 26 responses are 200 OK
In Splunk found 28 response back, so wrk lost 2, which is expected
Request seems OK because it shows success=true

./wrk -t10 -c100 -d5m -s test1.lua --timeout 60000  urlx
instance crash after a while, one instance can not take more than 100

./wrk -t10 -c50 -d5m -s test1.lua --timeout 60000  urlx
10 threads and 50 connections

  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    13.36s     2.94s   31.77s    95.15%
    Req/Sec     0.76      1.96    19.00     90.88%
  1097 requests in 5.00m, 1.68GB read
Requests/sec:      3.66
Transfer/sec:      5.74MB
thread 1 made 119 requests and got 113 responses, 113 responses are 200 OK

about 4 transaction per second

Heap memory usage is 763MB, 400 threads

./wrk -t10 -c70 -d5m -s test1.lua --timeout 60000  urlx
10 threads and 70 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    15.57s     5.24s   44.06s    92.91%
    Req/Sec     1.08      2.35    20.00     90.18%
  1347 requests in 5.00m, 2.06GB read
Requests/sec:      4.49
Transfer/sec:      7.02MB
thread 1 made 142 requests and got 134 responses, 134 responses are 200 OK

Heap memory usage is 810MB, 460 threads
about 4.5 transaction per second


