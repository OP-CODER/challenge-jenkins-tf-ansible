output "inventory" {
  value = <<EOT
[frontend]
r9.local ansible_host=${aws_instance.r9.public_ip} ansible_user=ec2-user

[backend]
d12.local ansible_host=${aws_instance.d12.public_ip} ansible_user=admin

[all:vars]
ansible_private_key_file=/var/lib/jenkins/.jenkins-tf.pem
ansible_connection=ssh
ansible_python_interpreter=/usr/bin/python3

EOT
}
