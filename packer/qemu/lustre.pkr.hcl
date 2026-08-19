packer {
  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = "~> 1"
    }
  }
}

variable "repo_url" {
  type    = string
  default = "https://github.com/ecce-machina/lustre_lab.git"
}

variable "repo_ref" {
  type    = string
  default = "main"
}

source "qemu" "lustre" {
  iso_url      = "https://download.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2"
  iso_checksum = "none"

  disk_image = true
  format     = "qcow2"

  output_directory = "output"
  vm_name          = "lustre-lab-rocky9.qcow2"

  disk_size = "40G"

  memory = 4096
  cpus   = 4

  headless = true

  ssh_username = "rocky"
  ssh_timeout  = "20m"

  net_device     = "virtio-net"
  disk_interface = "virtio"
  cd_label       = "cidata"

  cd_content = {
    "meta-data" = <<-EOF
      instance-id: lustre-packer
      local-hostname: lustre-packer
    EOF

    "user-data" = templatefile("${path.root}/cloud-init/user-data", {
      ssh_key = "{{ .SSHPublicKey }}"
    })
  }
}



build {
  name    = "lustre-lab-qemu"
  sources = ["source.qemu.lustre"]

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; sudo -E {{ .Vars }} {{ .Path }}"

    environment_vars = [
      "REPO_URL=${var.repo_url}",
      "REPO_REF=${var.repo_ref}",
    ]

    inline = [
      "set -euxo pipefail",
      "dnf -y install git",
      "rm -rf /opt/lustre-helpers",
      "git clone --branch \"$REPO_REF\" --depth 1 \"$REPO_URL\" /opt/lustre-helpers",
      "cd /opt/lustre-helpers",
      "bash install_pkgs.sh",
    ]
  }

  provisioner "shell" {
    execute_command   = "chmod +x {{ .Path }}; sudo -E {{ .Vars }} {{ .Path }}"
    expect_disconnect = true

    inline = [
      "sync",
      "systemctl reboot",
    ]
  }

  provisioner "shell" {
    pause_before    = "30s"
    execute_command = "chmod +x {{ .Path }}; sudo -E {{ .Vars }} {{ .Path }}"

    inline = [
      "set -euxo pipefail",
      "cd /opt/lustre-helpers",
      "bash build_lustre.sh --method rpm",
      <<-EOT
        LUSTRE_KERNEL="$(
          rpm -qa --qf '%%{NAME} %%{VERSION}-%%{RELEASE}.%%{ARCH}\n' |
            awk '$1 == "kernel" && $2 ~ /_lustre/ {print $2}' |
            sort -V |
            tail -1
        )"

        test -n "$LUSTRE_KERNEL"

        echo "$LUSTRE_KERNEL" > /opt/lustre-helpers/.lustre_kernel

        grubby --set-default "/boot/vmlinuz-$LUSTRE_KERNEL"
      EOT
    ]
  }

  provisioner "shell" {
    execute_command   = "chmod +x {{ .Path }}; sudo -E {{ .Vars }} {{ .Path }}"
    expect_disconnect = true

    inline = [
      "sync",
      "systemctl reboot",
    ]
  }

  provisioner "shell" {
    pause_before    = "30s"
    execute_command = "chmod +x {{ .Path }}; sudo -E {{ .Vars }} {{ .Path }}"

    inline = [
      <<-EOT
        set -euxo pipefail

        LUSTRE_KERNEL="$(cat /opt/lustre-helpers/.lustre_kernel)"

        test "$(uname -r)" = "$LUSTRE_KERNEL"

        depmod -a
        modprobe lustre
        modprobe ldiskfs
        modprobe osd_ldiskfs

        touch /opt/lustre-helpers/IMAGE_BUILD_DONE
      EOT
    ]
  }
}
