#####################################################
# Vpc Kubernetes cluster
# Copyright 2020 IBM
#####################################################

variable "cluster_name" {
    description = "Name of the cluster"
    type        = string
}

variable "vpc_id" {
    description = "The ID of the VPC that you want to use for your cluster."
    type        = string
}

variable "worker_pool_flavor" {
    description = " The flavor of the VPC worker node that you want to use."
    type        = string
}

variable "kube_version" {
    description = "The Kubernetes or OpenShift version that you want to set up in your cluster."
    type        = string
}

variable "update_all_workers" {
    description = "set to true, the Kubernetes version of the worker nodes is updated along with the Kubernetes version of the cluster that you specify in kube_version."
    type        = bool
}

variable "service_subnet" {
    description = "Specify a custom subnet CIDR to provide private IP addresses for services."
    type        = string
}

variable "pod_subnet" {
    description = "Specify a custom subnet CIDR to provide private IP addresses for pods."
    type        = string
}

variable "worker_nodes_per_zone"{
    description = "The number of worker nodes per zone in the default worker pool."
    type        = number
    default = 1
}

variable "worker_labels"{
    description = "Labels on all the workers in the default worker pool."
    type        = map
}

variable "resource_group_id" {
    description = "ID of resource group."
    type        = string
}

variable "wait_till" {
    description = "specify the stage when Terraform to mark the cluster creation as completed."
    type        = string
}

variable "disable_public_service_endpoint" {
    description = "Boolean value true if Public service endpoint to be disabled."
    type        = bool
}

variable "tags" {
    description = "List of tags."
    type        = list(string)
}

variable "cos_instance_crn" {
    description = "Enable openshift entitlement during cluster creation ."
    type        = string
}

variable "force_delete_storage" {
    description = "force the removal of persistent storage associated with the cluster during cluster deletion."
    type        = bool
}

variable "worker_zones" {
  type = map
  default = {}
}

variable "kms_config" {
  type = list(map(string))
  default = []
}
