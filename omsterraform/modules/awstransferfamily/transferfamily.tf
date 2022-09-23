terraform {                         #cloud provide information
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.51"
    }
  }
}
provider "aws" {                    # region information
  profile = "${var.profile}"
  region  = "${var.region}"
}

resource "aws_s3_bucket" "Transferbucket" {   #creating s3 bucket
  bucket = "${var.bucket}"

  tags = {
    Name        = "${var.bucket}"
    Environment = "${var.env}"
  }
}

resource "aws_s3_bucket_acl" "BucketACL" {  #s3 permissions
  bucket = "${var.bucket}".id
  acl    = "${var.env}"
}

resource "aws_transfer_ssh_key" "sshkey" {    # creating  ssh key to connect to the sftp server
  server_id = aws_transfer_server.TransferServer.id
  user_name = aws_transfer_user.TransferUser.user_name
  body      = "${var.keyvalue}"
}

resource "aws_transfer_server" "TransferServer" {     # creating sftp server
  identity_provider_type = "${var.identityprovider}"

  tags = {
    NAME = "sftp-transfer-server"
  }
}

resource "aws_transfer_user" "TransferUser" {       # creating sftp user
  server_id = aws_transfer_server.TransferServer.id
  user_name = "${var.user}"
  role      = aws_iam_role.Transferrole.arn
  home_directory_type = "LOGICAL"
  home_directory_mappings {
    entry  = "/"
    target = "/${"${var.bucket}".id}/$${ReceivedFiles}"
  }

  tags = {
    NAME = "${var.user}"
  }
}

resource "aws_iam_role" "Transferrole" {         # creating IAM role for transfer access
  name = "${var.role}"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "transfer.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "Transferpolicy" {   #attaching policy to the role
  name = "${var.policy}"
  role = aws_iam_role.Transferrole.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowFullAccesstoS3",
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}
