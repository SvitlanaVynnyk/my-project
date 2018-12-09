variable "gce_ssh_user" {
  default = "svitlana"
}
variable "gce_ssh_pub_key_file" {
  default = "/home/svitlana/.ssh/id_rsa.pub"
}

provider "google" {
  credentials = "${file("key.json")}"
  project     = "skilled-acolyte-219115"
  region      = "europe-west1"
  zone = "europe-west1-b"
}

resource "google_compute_subnetwork" "custom-subnet" {
  name = "eu-subnet"
  ip_cidr_range = "10.2.0.0/16"
  region = "europe-west1"
  network = "${google_compute_network.custom-network.self_link}"
}

resource "google_compute_network" "custom-network" {
  name = "network-test"
  auto_create_subnetworks = "false"
}

resource "google_compute_firewall" "custom-firewall-1" {
  name = "firewall-1"
  network = "${google_compute_network.custom-network.name}"
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports = ["22", "8080", "8082"]
  }
}

resource "google_compute_project_metadata_item" "svitlana" {
  key = "ssh-keys"
  value = ""
}

resource "google_compute_instance" "jenkins-instance" {
  name = "jenkins-master"
  machine_type = "g1-small"
  boot_disk {
    initialize_params {
      image = "ubuntu-1604-lts"
    }
  }
  network_interface {
    subnetwork = "${google_compute_subnetwo"
 
}

resource "google_compute_instance" "nexus-instance" {
  name = "nexus-artifactory"
  machine_type = "g1-small"
  boot_disk {
    initialize_params {
      image = "ubuntu-1604-lts"
    }
  }
  network_interface {
    subnetwork = "${google_compute_subnetwork.custom-subnet.name}"
    access_config = {
    }
  }

  
}

resource "google_compute_instance" "application-instance" {
  name = "application-server"
  machine_type = "g1-small"
  boot_disk {
    initialize_params {
      image = "ubuntu-1604-lts"
    }
  }
  network_interface {
    subnetwork = "${google_compute_subnetwork.custom-subnet.name}"
    access_config = {
    }
  }
  metadata {
    ssh-keys = "svitlana"
  }
}

resource "google_compute_disk" "persistant-disk-1" {
  name = "jenkins-home"
  size = "50"
}

resource "google_compute_disk" "persistant-disk-2" {
  name = "nexus-data"
  size = "50"

