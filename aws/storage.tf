resource "aws_ebs_volume" "mdt" {
  availability_zone = var.availability_zone
  size              = var.mdt_disk_size_gb
  type              = "gp3"

  tags = {
    Name = "lustre-mdt"
    Role = "mdt"
  }
}

resource "aws_volume_attachment" "mdt" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.mdt.id
  instance_id = aws_instance.mgs.id
}

resource "aws_ebs_volume" "ost" {
  count = var.oss_count

  availability_zone = var.availability_zone
  size              = var.ost_disk_size_gb
  type              = "gp3"

  tags = {
    Name = "lustre-ost${count.index + 1}"
    Role = "ost"
  }
}

resource "aws_volume_attachment" "ost" {
  count = var.oss_count

  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.ost[count.index].id
  instance_id = aws_instance.oss[count.index].id
}
