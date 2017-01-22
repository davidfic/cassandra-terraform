resource "aws_instance" "cassandra" {
    count = "${var.count}"
    ami = "${lookup(var.ami, var.region)}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    vpc_security_group_ids = ["${aws_security_group.main_security_group.id}"]
    subnet_id = "${var.subnet_id_1}"
    count = 1
    disable_api_termination=false
    root_block_device {
        volume_size = "20"
        delete_on_termination = true
    }
    ebs_block_device {
      device_name = "/dev/sdh"
      volume_size = "${var.ebs_size_gb}"
      volume_type = "gp2"
      encrypted = true
      delete_on_termination = true
    }
    tags {
    	Name =  "Cassandra"
      Env = "${var.environment}"
    }

    connection {
    	user = "ubuntu"
    	key_file = "${var.key_path}"
    }
    // format and mount the EBS volume
    provisioner "remote-exec" {
      inline = [
      "while [ ! -e /dev/xvdh ]; do sleep 1; done",
      "sudo mkfs -t ext4 /dev/xvdh",
      "sudo mkdir /data",
      "sudo mount /dev/xvdh /data",
      "echo '/dev/xvdf  /data  ext4  defaults,nofail,nobootwait  0 0' | sudo tee -a /etc/fstab",
      "sudo mount -a",
      "sudo apt-get -y install python",
      "sudo apt-get -y install git"
      ]
    }
}

