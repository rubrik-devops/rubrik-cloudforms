# Rubrik Management Pack for CloudForms

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

# :blue_book: Documentation 

Here are some resources to get you started! If you find any challenges from this project are not properly documented or are unclear, please [raise an issue](https://github.com/rubrikinc/rubrik-management-pack-for-cloudforms/issues/new/choose) and let us know! This is a fun, safe environment - don't worry if you're a GitHub newbie! :heart:

* [Quick Start Guide](https://github.com/rubrikinc/rubrik-management-pack-for-cloudforms/blob/master/docs/quick-start.md)
* [BLOG: Backup-as-a-Service with Rubrik and Red Hat CloudForms](https://www.rubrik.com/blog/backup-as-a-service-rubrik-cloudforms/)

# :muscle: How You Can Help

We glady welcome contributions from the community. From updating the documentation to adding more Intents for Roxie, all ideas are welcome. Thank you in advance for all of your issues, pull requests, and comments! :star:

* [Contributing Guide](CONTRIBUTING.md)
* [Code of Conduct](CODE_OF_CONDUCT.md)

# :pushpin: License

* [MIT License](LICENSE)

# :point_right: About Rubrik Build

We encourage all contributors to become members. We aim to grow an active, healthy community of contributors, reviewers, and code owners. Learn more in our [Welcome to the Rubrik Build Community](https://github.com/rubrikinc/welcome-to-rubrik-build) page.
