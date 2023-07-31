job "mgroup" {
  region    = "us"
  namespace = "apps"
  type      = "service"

  meta {
    run_uuid = "${uuidv4()}"
  }

  constraint {
    attribute = "${meta.role}"
    value     = "client"
  }

  group "mgroup_app" {
    count = 3

    network {
      port "http" {
        to = 3000
      }
    }

    task "mgroup_app" {
      driver = "docker"

      service {
        name     = "mgroup-app"
        port     = "http"
        provider = "nomad"
      }

      artifact {
        source      = "git::https://github.com/gkspranger/python-flask-memcached"
        destination = "local/app"
      }

      template {
        destination = "local/run.sh"
        perms       = "755"
        data        = <<-EOH
#!/usr/bin/env sh

cd local/app
python -m pip install --upgrade pip
pip install -r requirements.txt

python app/
        EOH
      }

      config {
        image = "public.ecr.aws/docker/library/python:3.11.4"
        ports = ["http"]

        entrypoint = [
          "local/run.sh"
        ]
      }

      resources {
        memory = 1024
      }
    }
  }

  group "mgroup_memcached" {
    count = 1

    network {
      port "tcp" {
        to = 11211
      }
    }

    task "mgroup_memcached" {
      driver = "docker"

      service {
        name     = "mgroup-memcached"
        port     = "tcp"
        provider = "nomad"
      }

      config {
        image = "public.ecr.aws/docker/library/memcached:1.6.21-alpine3.18"
        ports = ["tcp"]
      }

      resources {
        memory = 1024
      }
    }
  }
}
