output "image_family" {
  value = var.image_family
}

output "mds_private_ip" {
  value = google_compute_instance.mds.network_interface[0].network_ip
}

output "oss_private_ips" {
  value = google_compute_instance.oss[*].network_interface[0].network_ip
}

output "client_private_ips" {
  value = google_compute_instance.client[*].network_interface[0].network_ip
}

output "client_names" {
  value = google_compute_instance.client[*].name
}

output "oss_names" {
  value = google_compute_instance.oss[*].name
}
