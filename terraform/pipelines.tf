locals {
  pipelines = {}
  streams = {
    dummy_stream = {
        name = "dummy_stream"
        cpu = 512
        memory = 1024
    }
  }
}