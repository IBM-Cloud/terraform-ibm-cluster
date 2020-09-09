#####################################################
# classic kubernetes multi-zone cluster
# Copyright 2020 IBM
#####################################################

resource "ibm_container_cluster" "cluster" {
  name                     = var.cluster_name
  datacenter               = var.metro
  default_pool_size        = var.worker_nodes_per_zone
  resource_group_id        = var.resource_group_id
  machine_type             = var.worker_pool_flavor
  public_vlan_id           = var.public_vlan
  private_vlan_id          = var.private_vlan
  hardware                 = var.hardware
  public_service_endpoint  = var.master_service_public_endpoint
  private_service_endpoint = var.master_service_private_endpoint
  disk_encryption          = var.encrypt_local_disk
  force_delete_storage     = var.force_delete_storage
  gateway_enabled          = var.gateway_enabled
  kube_version             = var.kube_version
  no_subnet                = var.no_subnet
  update_all_workers       = var.update_all_workers
  tags                     = var.tags

  dynamic workers_info {
    for_each = var.workers_info
    content {
      id           = (workers_info.value.id != "" ? workers_info.value.id : null)  
      version      = (workers_info.value.version != "" ? workers_info.value.version : null)  
    }
  }

  dynamic kms_config {
    for_each = var.kms_config
    content {
      instance_id      = kms_config.value.instance_id
      crk_id           = kms_config.value.crk_id
      private_endpoint = (kms_config.value.private_endpoint ? true: false)
    }
  }

  dynamic webhook {
    for_each = var.webhook
    content {
      level = webhook.value.level
      type  = webhook.value.type
      url   = webhook.value.url
    }
  }
}

resource "ibm_container_worker_pool_zone_attachment" "zones" {
 cluster           = ibm_container_cluster.cluster.id
 worker_pool       = ibm_container_cluster.cluster.worker_pools.0.id
 resource_group_id = var.resource_group_id
 wait_till_albs    = var.wait_till_albs

 for_each          = var.worker_zones
 zone              = each.key
 public_vlan_id    = each.value["public_vlan"] 
 private_vlan_id   = each.value["private_vlan"]
 
}

