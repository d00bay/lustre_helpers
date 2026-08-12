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

resource "aws_ebs_volume" "ost1" {
  availability_zone = var.availability_zone
  size              = var.ost_disk_size_gb
  type              = "gp3"

  tags = {
    Name = "lustre-ost1"
    Role = "ost"
  }
}

resource "aws_volume_attachment" "ost1" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.ost1.id
  instance_id = aws_instance.oss1.id
}
