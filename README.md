# Rubrik Management Pack for CloudForms

## Overview

This repository contains the Rubrik Management Pack for CloudForms, which is usable in [Red Hat CloudForms](https://www.redhat.com/en/technologies/management/cloudforms) and [ManageIQ](https://manageiq.org).

This provides integration between the Cloud Management Platform, and the Rubrik platform protecting it; allowing the configuration and management of workloads protected by Rubrik through a single console.

## Catalog Services

This pack provides the following catalog services:

* **Add a Rubrik Cluster** - used to add a Rubrik cluster to the CloudForms configuration
* **Delete a Rubrik Cluster** - used to remove a Rubrik cluster from the CloudForms configuration
* **Provision and Protect VM** - a demonstrative workflow used to protect a new VMware VM as part of a provisioning activity

## Custom Buttons

This pack contains the following buttons added to virtual machines to aid in workload backup and recovery:

* **Modify SLA Domain** - used to modify the SLA Domain policy assigned to a virtual machine
* **Request a Live Mount** - uses Rubrik's Live Mount feature to instantly recover a point in time snapshot of the VM to vCenter
* **Take On-Demand Snapshot** - takes an ad-hoc snapshot, using either the already assigned SLA Domain policy, or a different policy

