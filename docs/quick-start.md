# Quick Start: Rubrik Management Pack for CloudForms

This document details the installation and usage of the Rubrik Management Pack for CloudForms. The management pack was created to provide integration between RedHat CloudForms and Rubrik’s REST API to manage protection for CloudForms managed virtual machine resources.

The management pack can also be used on the ManageIQ open-source project, which is the upstream version of RedHat CloudForms.

## Requirements
The management pack was built on ManageIQ Fine release (equivalent to RedHat CloudForms 4.5), and has also been tested on ManageIQ Euwe release (CloudForms 4.2 equivalent). It has been tested and validated against Rubrik Cloud Data Management version 4.0 and 4.1.

## Installing Rubrik Management Pack for CloudForms
This section provides details on installation and configuration. 

### Downloading and installing the content
* Logon to the ManageIQ server via SSH (default credentials: root / smartvm)
* Install the rhconsulting rake scripts using the following commands:

```
git clone https://github.com/rhtconsulting/cfme-rhconsulting-scripts.git
cd cfme-rhconsulting-scripts/
make install
```

Example output:

```
[root@localhost ~]# git clone https://github.com/rhtconsulting/cfme-rhconsulting-scripts.git
Cloning into 'cfme-rhconsulting-scripts'...
remote: Counting objects: 565, done.
remote: Total 565 (delta 0), reused 0 (delta 0), pack-reused 565
Receiving objects: 100% (565/565), 134.57 KiB | 0 bytes/s, done.
Resolving deltas: 100% (339/339), done.
[root@localhost ~]# cd cfme-rhconsulting-scripts/
[root@localhost cfme-rhconsulting-scripts]# make install
install -Dm644 rhconsulting_buttons.rake /var/www/miq/vmdb/lib/tasks/rhconsulting_buttons.rake
install -Dm644 rhconsulting_customization_templates.rake /var/www/miq/vmdb/lib/tasks/rhconsulting_customization_templates.rake
install -Dm644 rhconsulting_provision_dialogs.rake /var/www/miq/vmdb/lib/tasks/rhconsulting_provision_dialogs.rake
install -Dm644 rhconsulting_service_dialogs.rake /var/www/miq/vmdb/lib/tasks/rhconsulting_service_dialogs.rake
install -Dm644 rhconsulting_miq_ae_datastore.rake /var/www/miq/vmdb/lib/tasks/rhconsulting_miq_ae_datastore.rake
install -Dm644 rhconsulting_roles.rake /var/www/miq/vmdb/lib/tasks/rhconsulting_roles.rake
install -Dm644 rhconsulting_service_catalogs.rake /var/www/miq/vmdb/lib/tasks/rhconsulting_service_catalogs.rake
install -Dm644 rhconsulting_tags.rake /var/www/miq/vmdb/lib/tasks/rhconsulting_tags.rake
install -Dm644 rhconsulting_reports.rake /var/www/miq/vmdb/lib/tasks/rhconsulting_reports.rake
install -Dm644 rhconsulting_widgets.rake /var/www/miq/vmdb/lib/tasks/rhconsulting_widgets.rake
install -Dm644 rhconsulting_policies.rake /var/www/miq/vmdb/lib/tasks/rhconsulting_policies.rake
install -Dm644 rhconsulting_alerts.rake /var/www/miq/vmdb/lib/tasks/rhconsulting_alerts.rake
install -Dm644 rhconsulting_illegal_chars.rb /var/www/miq/vmdb/lib/tasks/rhconsulting_illegal_chars.rb
install -Dm644 rhconsulting_options.rb /var/www/miq/vmdb/lib/tasks/rhconsulting_options.rb
install -Dm755 bin/miqexport /usr/bin/miqexport
install -Dm755 bin/miqimport /usr/bin/miqimport
install -Dm755 bin/export-miqdomain /usr/bin/export-miqdomain
install -Dm755 bin/import-miqdomain /usr/bin/import-miqdomain
[root@localhost cfme-rhconsulting-scripts]#
```

* Clone the Rubrik Management Pack Repository:

```
cd ~
git clone https://github.com/rubrik-devops/rubrik-cloudforms
```

Example output:

```
[root@localhost cfme-rhconsulting-scripts]# cd
[root@localhost ~]# git clone https://github.com/rubrik-devops/rubrik-cloudforms
Cloning into 'rubrik-cloudforms'...
remote: Counting objects: 145, done.
remote: Compressing objects: 100% (65/65), done.
remote: Total 145 (delta 75), reused 145 (delta 75), pack-reused 0
Receiving objects: 100% (145/145), 30.79 KiB | 0 bytes/s, done.
Resolving deltas: 100% (75/75), done.
[root@localhost ~]#
```

* Run the `miqimport` tool with the following commands:

```
cd cfme-rhconsulting-scripts/bin/
miqimport domain Rubrik ~/rubrik-cloudforms/automate/
miqimport service_dialogs ~/rubrik-cloudforms/service_dialogs/
miqimport service_catalogs ~/rubrik-cloudforms/service_catalogs/
miqimport buttons ~/rubrik-cloudforms/buttons/
```

Example output:

```
[root@localhost bin]# cd cfme-rhconsulting-scripts/bin/
[root@localhost bin]# miqimport domain Rubrik ~/rubrik-cloudforms/automate/
DOMAIN_OPTIONS=overwrite=false;enabled=true;
/var/www/miq/vmdb ~/cfme-rhconsulting-scripts/bin
~/cfme-rhconsulting-scripts/bin
[root@localhost bin]# miqimport service_dialogs ~/rubrik-cloudforms/service_dialogs/
/var/www/miq/vmdb ~/cfme-rhconsulting-scripts/bin
Dialog: [Rubrik - Add Cluster]
Dialog: [Rubrik - Live Mount]
Dialog: [Rubrik - On-Demand Snapshot]
Dialog: [Rubrik - Provision and Protect VM]
Dialog: [Rubrik - Remove Cluster]
Dialog: [Rubrik - Select SLA Domain]
~/cfme-rhconsulting-scripts/bin
[root@localhost bin]# miqimport service_catalogs ~/rubrik-cloudforms/service_catalogs/
/var/www/miq/vmdb ~/cfme-rhconsulting-scripts/bin
Service Catalog: [Rubrik]
Catalog Item: [Add a Rubrik Cluster]
Catalog Item: [Delete a Rubrik Cluster]
Catalog Item: [RubrikDemoVM]
Catalog Item: [Provision and Protect VM]
~/cfme-rhconsulting-scripts/bin
[root@localhost bin]# miqimport buttons ~/rubrik-cloudforms/buttons/
/var/www/miq/vmdb ~/cfme-rhconsulting-scripts/bin
Button Class: [Vm]
        Button Group: [Rubrik]
                Adding Button: Modify SLA Domain
                Adding Button: Request a Live Mount
                Adding Button: Take On-Demand Snapshot
~/cfme-rhconsulting-scripts/bin
[root@localhost bin]#
```

### Changes in CloudForms Console

Creating a VM Service Catalog Item
To use the `Provision and Protect VM` catalog item, a VM template Service Catalog Item will be needed. To create this follow the steps below in the web UI:

* Go to **Services** > **Catalog Items**
* Select the **Rubrik Catalog**
* Click **Configuration** > **Add a New Catalog Item**
* Select **VMware** from the drop down
* Complete the form as follows:
    * **Name:** DemoVM (or anything you like)
    * **Catalog:** Rubrik
    * **Dialog:** <No Dialog>
    * **Provisioning Entry Point:** Choose the following instance:
        `/Service/Provisioning/StateMachines/ServiceProvision_Template/CatalogItemInitialization`
    * **Reconfigure Entry Point:** <none>
    * **Retirement Entry Point:** <leave default>
* Select the **Request Info** tab
* Under each tab, specify the configuration for the resulting VMs based on your own infrastructure
* Click **Add**

#### Configure the Provision and Protect VM Catalog Item
The Provision and Protect VM catalog item needs to be configured to use the VM provisioning catalog item we just created. To do this, follow the steps below in the web interface:

* Go to **Services** > **Catalog Items**
* Select the Rubrik Catalog
* Select the Provision and Protect VM catalog item, select **Configuration** > **Edit this Item**
* Go to the **Resources** tab
* Select the catalog item you provisioned in the last section from the **Add a Resource** dropdown
* Click **Save**

The Provision and Protect VM catalog item is now ready to use.

### Adding Icons to Rubrik services
The Rubrik icons from the management pack need to be added to the catalog items, as this is not done on import. The icons are included in the repository under the `images` folder, 

To replace these, go to **Services** > **Catalogs** > **Catalog Items** > **Rubrik**, select the relevant service from the table below and import the listed icon from the table below:

| Catalog Item             | File Name       |
|--------------------------|-----------------|
| Add a Rubrik Cluster     | rubrik_logo.png |
| Delete a Rubrik Cluster  | rubrik_logo.png |
| Provision and Protect VM | rubrik_vm.png   |

## Using the Rubrik Management Pack for CloudForms
This section provides operational information. 

### Custom Attributes
Once a VM has been provisioned (through the `Provision and Protect VM` workflow), or its SLA Domain has been updated (via the `Modify SLA Domain` button), two Custom Attributes will be added to the VM object in CloudForms, these are used to identify the Rubrik cluster responsible for protecting the VM, and the SLA Domain policy it is protected by. These can be seen in the below screenshot:

![alt text](/docs/images/image1.png)

### Services Catalog
There are three items in the Service Catalog, below is a brief description of each, followed by a step-by-step guide to using them.

* `Add a Rubrik Cluster` - used to add a new Rubrik cluster to the configuration
* `Delete a Rubrik Cluster` - used to delete a Rubrik cluster from the configuration
* `Provision and Protect VM` - a demonstrative workflow, showing how protection can be included as part of a provisioning workflow

#### Add a Rubrik Cluster
* Click on **Services** > **Service Catalog** > **Rubrik** > **Add a Rubrik Cluster**

![alt text](/docs/images/image2.png)

* Click **Order** to order this service

![alt text](/docs/images/image3.png)

* Enter the following details:

   * **Cluster Name** - a name to identify the cluster or site by
   * **Hostname or IP** - the hostname or IP of a node in the Rubrik cluster
   * **Username** - the username to use to connect to the Rubrik cluster. This should have administrative permissions.
   * **Password** - the password for the account entered in the **Username** box

![alt text](/docs/images/image4.png)

* Click **Submit**, the request can be monitored through the Requests window which is displayed. The request should go to **Ok** / **Finished** when complete (as shown below)

![alt text](/docs/images/image5.png)

#### Delete a Rubrik Cluster
* Click on **Services** > **Service Catalog** > **Rubrik** > **Delete a Rubrik Cluster**

![alt text](/docs/images/image6.png)

* Click **Order** to order this service

![alt text](/docs/images/image7.png)

* Select the site you want to delete from the drop-down service
* Click **Submit**, the request can be monitored through the Requests window which is displayed. The request should go to **Ok** / **Finished** when complete (as shown below). 

![alt text](/docs/images/image5.png)

#### Provision and Protect VM
* Click on **Services** > **Service Catalog** > **Rubrik** > **Provision and Protect VM**

![alt text](/docs/images/image8.png)

* Click **Order** to order this service

![alt text](/docs/images/image9.png)

* Enter the following details:
  * **VM Name** - the name for the new test VM
  * **Rubrik Site** - the site for the Rubrik cluster which should protect this VM - **note** that this should be connected to the vCenter that the VM is being provisioned into
  * **Rubrik SLA Domain** - the SLA Domain policy which the VM should be protected under
* Click **Submit**, the request can be monitored through the Requests window which is displayed. The request should go to **Ok** / **Finished** when complete (as shown below)

![alt text](/docs/images/image5.png)

### Buttons
There are three buttons available on each VM, below is a brief description of each, followed by a step-by-step guide to using them.

* **Modify SLA Domain** - alters the existing SLA Domain policy for the VM
* **Take On-Demand Snapshot* - takes a snapshot of the VM, using either the configured SLA Domain, or an alternative one
* **Request a Live Mount** - request a selected snapshot be recovered to vCenter using Rubrik’s Live Mount feature

#### Modify SLA Domain
* From the VM, select **Rubrik** > **Modify SLA Domain** from the top bar

![alt text](/docs/images/image10.png)

Select the Rubrik site which should protect the VM (note that this should be connected to the vCenter that the VM belongs to), and the SLA Domain policy to protect the VM with

![alt text](/docs/images/image11.png)

Click **Submit** to place the Order Request, the workflow will update the SLA Domain policy, and the Custom Attributes on the VM

#### Take On-Demand Snapshot
From the VM, select **Rubrik** > **Take On-Demand Snapshot** from the top bar

![alt text](/docs/images/image10.png)

* Enter the following details:
  * **Use Configured SLA Domain?** - if set to true (default), the snapshot will use the SLA Domain policy already configured on the Rubrik system
  * **Select Rubrik Site** - select the Rubrik site which should snapshot the VM (note that this should be connected to the vCenter that the VM belongs to) - only used if **Use Configured SLA Domain** is unchecked
  * **SLA Domain Name** - select the Rubrik SLA Domain policy which the snapshot should adhere to - only used if **Use Configured SLA Domain** is unchecked

![alt text](/docs/images/image12.png)

Click **Submit** to place the Order Request, the workflow will schedule the on-demand snapshot for the VM

#### Request a Live Mount
From the VM, select **Rubrik** > **Request Live Mount** from the top bar

![alt text](/docs/images/image10.png)

* Enter the following details:
  * **Snapshot** - select the snapshot you want to restore from
  * **Remove Network Devices** - default behaviour in Rubrik is to disconnect any network devices when performing a Live Mount, in order to remove risk of causing conflicts with production VMs, if this box is unchecked then the vNIC will also removed from the VM, not just disconnected (default false)

![alt text](/docs/images/image13.png)

* Click **Submit** to place the Order Request, the workflow will schedule the Live Mount of the snapshot for the VM, which can then be accessed via vCenter
