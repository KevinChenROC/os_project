require 'concurrent'
semaphore = Concurrent::Semaphore.new(2)

t1 = Thread.new do
  semaphore.acquire
  puts "Thread 1 acquired semaphore"
end

t2 = Thread.new do
  semaphore.acquire
  puts "Thread 2 acquired semaphore"
end

t3 = Thread.new do
  semaphore.acquire
  puts "Thread 3 acquired semaphore"
end

t4 = Thread.new do
  sleep(2)
  puts "Thread 4 releasing semaphore"
  semaphore.release
end

[t1, t2, t3, t4].each(&:join)

puts semaphore.available_permits
