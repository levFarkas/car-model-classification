variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "project_name" {
  type    = string
  default = "car-modelling"
}

variable "runtime" {
  type    = string
  default = "python3.7"
}

variable "memory_size" {
  type    = string
  default = "128"
}

variable "timeout" {
  type    = string
  default = "200"
}

variable "training_instance_type" {
  type = string
}

variable "inference_instance_type" {
  type = string
}

variable "volume_size_sagemaker" {
  type = number
}

variable "s3_bucket_input_training_path" {
  type = string
}

variable "s3_bucket_output_models_path" {
  type = string
}
