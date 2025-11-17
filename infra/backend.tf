resource "aws_s3_bucket" "tf_state" {
  bucket = "cloud-final-tfstate-${random_id.suffix.hex}"
  force_destroy = true

  versioning {
    enabled = true
  }

  tags = {
    Name = "cloud-final-tfstate"
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_dynamodb_table" "tf_locks" {
  name         = "cloud-final-tfstate-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "cloud-final-tfstate-locks"
  }
}

terraform {
  backend "s3" {
    bucket         = "cloud-final-tfstate-5312ca9b"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "cloud-final-tfstate-locks"
    encrypt        = true
  }
}