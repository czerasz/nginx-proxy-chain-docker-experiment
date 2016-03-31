# Nginx Proxy Chain Docker Experiment

Start `20` containers with:

```bash
./scripts/start.sh start 20
```

Remove the `20` containers by passing the `delete` argument:

```bash
./scripts/start.sh delete 20
```

Test the nginx proxy chain with [ab](https://httpd.apache.org/docs/2.4/programs/ab.html) inside a container:

```bash
docker run -it \
           --rm \
           --name=benchmark \
           --link=nginx-0:nginx \
           jordi/ab ab -n 100 -c 10 http://nginx/ping
```

Simply test the response:

```bash
curl localhost:8080/ping
```

## Sample Results

For `50` nginx container

```
$ docker run -it --rm --name=bench --link=nginx-0:nginx jordi/ab ab -n 100 -c 10 http://nginx/ping

...

Benchmarking nginx (be patient).....done


Server Software:        nginx/1.9.12
Server Hostname:        nginx
Server Port:            80

Document Path:          /ping
Document Length:        18 bytes

Concurrency Level:      10
Time taken for tests:   1.445 seconds
Complete requests:      100
Failed requests:        0
Total transferred:      24900 bytes
HTML transferred:       1800 bytes
Requests per second:    69.21 [#/sec] (mean)
Time per request:       144.485 [ms] (mean)
Time per request:       14.449 [ms] (mean, across all concurrent requests)
Transfer rate:          16.83 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    1   1.1      0       6
Processing:    71  140  30.0    142     198
Waiting:       71  140  30.1    142     198
Total:         72  141  30.1    142     201

Percentage of the requests served within a certain time (ms)
  50%    142
  66%    156
  75%    164
  80%    170
  90%    178
  95%    185
  98%    191
  99%    201
 100%    201 (longest request)
```

```
$ free -t -m
             total       used       free     shared    buffers     cached
Mem:          3956       1444       2511          4        160        768
-/+ buffers/cache:        515       3440
Swap:            0          0          0
Total:        3956       1444       2511
```

---

For `100` nginx container

```
$ docker run -it --rm --name=bench --link=nginx-0:nginx jordi/ab ab -n 100 -c 10 http://nginx/ping

...

Benchmarking nginx (be patient).....done


Server Software:        nginx/1.9.12
Server Hostname:        nginx
Server Port:            80

Document Path:          /ping
Document Length:        18 bytes

Concurrency Level:      10
Time taken for tests:   2.209 seconds
Complete requests:      100
Failed requests:        0
Total transferred:      24900 bytes
HTML transferred:       1800 bytes
Requests per second:    45.28 [#/sec] (mean)
Time per request:       220.852 [ms] (mean)
Time per request:       22.085 [ms] (mean, across all concurrent requests)
Transfer rate:          11.01 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    1   3.7      0      35
Processing:   101  215  54.6    211     378
Waiting:      101  215  53.6    211     366
Total:        101  216  56.4    211     384

Percentage of the requests served within a certain time (ms)
  50%    211
  66%    221
  75%    233
  80%    241
  90%    273
  95%    360
  98%    384
  99%    384
 100%    384 (longest request)
 ```

```
$ free -t -m
             total       used       free     shared    buffers     cached
Mem:          3956        892       3064          5         66        339
-/+ buffers/cache:        486       3470
Swap:            0          0          0
Total:        3956        892       3064
```

---

For `200` nginx container

```
$ docker run -it --rm --name=bench --link=nginx-0:nginx jordi/ab ab -n 100 -c 10 http://nginx/ping

...

Benchmarking nginx (be patient).....done


Server Software:        nginx/1.9.12
Server Hostname:        nginx
Server Port:            80

Document Path:          /ping
Document Length:        18 bytes

Concurrency Level:      10
Time taken for tests:   4.087 seconds
Complete requests:      100
Failed requests:        0
Total transferred:      24900 bytes
HTML transferred:       1800 bytes
Requests per second:    24.47 [#/sec] (mean)
Time per request:       408.697 [ms] (mean)
Time per request:       40.870 [ms] (mean, across all concurrent requests)
Transfer rate:          5.95 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.5      0       3
Processing:   233  400  75.4    392     659
Waiting:      233  400  75.5    392     659
Total:        234  400  75.6    392     659

Percentage of the requests served within a certain time (ms)
  50%    392
  66%    420
  75%    431
  80%    437
  90%    481
  95%    591
  98%    645
  99%    659
 100%    659 (longest request)
```

```
$ free -t -m
             total       used       free     shared    buffers     cached
Mem:          3956       1926       2030         12        188        791
-/+ buffers/cache:        945       3011
Swap:            0          0          0
Total:        3956       1926       2030
```
