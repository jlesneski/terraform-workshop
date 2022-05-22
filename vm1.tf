resource "aws_network_interface" "vm1_nic1" {
  subnet_id   = aws_subnet.vms_subnet.id
  private_ips = ["10.100.1.71"]

  tags = {
    Name = lower("vm1-${terraform.workspace}-nic1")
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu_latest.id
  instance_type = "t3.micro"

  network_interface {
    network_interface_id = aws_network_interface.vm1_nic1.id
    device_index         = 0
  }
  tags = {
    Name = lower("vm1-${terraform.workspace}-web1")
  }
}