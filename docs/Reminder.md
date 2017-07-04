# Reminder
This section will present few commands & a general reminder. 

***

**Table of Content**

* [Starting the Guest Box](#starting-the-guest-box)

* [Connecting to the Guest Box](#connecting-to-the-guest-box)

* [Applying a Configuration Change](#box-provisioning)

* [Database Credentials](#database-credentials)

***

<a id="starting-the-guest-box"></a>
# Starting the Guest Box

You can start vagrant box by issuing the following command:
`homestead up`

<a id="connecting-to-the-guest-box"></a>
# Connecting to the Guest Box

You can connect to the vagrant box by issuing the following command:
`homestead ssh`

<a id="box-provisioning"></a>
# Applying a Configuration Change

Always re-provision you vagrant box in order to apply configuration changes.
`homestead reload --provision`

<a id="database-credentials"></a>
# Database Credentials
 
Homestead default credentials are as follows:

* host: `127.0.0.1`
* user: `homestead`
* password: `secret`
