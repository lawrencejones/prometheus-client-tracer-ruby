# frozen_string_literal: true

# This file can be used to validate the performance of the tracer is not incomparible to a
# naive tracing implementation. The performance will degrade linerarly with the number of
# on-going traces, however a modern i7 can achieve trace throughput:
#
#   naive: 333k/s
#   trace,   0 on-going: 233k/s
#   trace,   5 on-going: 216k/s
#   trace,  25 on-going: 155k/s
#   trace, 100 on-going: 84k/s
#
# While this seems more than reasonable performance for almost any use case, consider
# using multiple tracers if this does become a problem.

require "benchmark"

require "prometheus/client"
require "prometheus/client/tracer"

counter = Prometheus::Client::Counter.new(
  :counter, docstring: "example", labels: %i[worker]
)
another_counter = Prometheus::Client::Counter.new(
  :counter_another, docstring: "another example", labels: %i[]
)

def trace(metric, labels = {})
  start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  yield
ensure
  metric.increment(
    by: Process.clock_gettime(Process::CLOCK_MONOTONIC) - start,
    labels: labels,
  )
end

n_string, n_concurrent_traces_string, = ARGV
n, n_concurrent_traces = [n_string.to_i, n_concurrent_traces_string.to_i]

n_concurrent_traces.times do
  Prometheus::Client.tracer.send(:start, another_counter, {})
end

Benchmark.bm(7) do |x|
  x.report("naive:") { n.times { trace(counter, worker: 1) { nil } } }
  x.report("trace:") do
    n.times { Prometheus::Client.tracer.trace(counter, worker: 1) { nil } }
  end
end
