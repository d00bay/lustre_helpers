
resource "aws_instance" "mgs" {
  ami                    = data.aws_ami.lustre.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.cluster.id
  vpc_security_group_ids = [aws_security_group.cluster.id]

  key_name             = aws_key_pair.lustre_lab.key_name
  iam_instance_profile = aws_iam_instance_profile.image_builder.name

  associate_public_ip_address = true

  user_data_replace_on_change = true

  root_block_device {
    volume_size = var.boot_disk_size_gb
    volume_type = "gp3"
  }

  tags = {
    Name = "lustre-mgs"
    Role = "mgs"
  }
}

resource "aws_instance" "oss1" {
  ami                    = data.aws_ami.lustre.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.cluster.id
  vpc_security_group_ids = [aws_security_group.cluster.id]

  key_name             = aws_key_pair.lustre_lab.key_name
  iam_instance_profile = aws_iam_instance_profile.image_builder.name

  associate_public_ip_address = true

  root_block_device {
    volume_size = var.boot_disk_size_gb
    volume_type = "gp3"
  }

  tags = {
    Name = "lustre-oss1"
    Role = "oss"
  }
}

resource "aws_instance" "client1" {
  ami                    = data.aws_ami.lustre.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.cluster.id
  vpc_security_group_ids = [aws_security_group.cluster.id]

  key_name             = aws_key_pair.lustre_lab.key_name
  iam_instance_profile = aws_iam_instance_profile.image_builder.name

  associate_public_ip_address = true

  root_block_device {
    volume_size = var.boot_disk_size_gb
    volume_type = "gp3"
  }

  tags = {
    Name = "lustre-client1"
    Role = "client"
  }
}

