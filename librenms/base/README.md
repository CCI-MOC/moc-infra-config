# Post install config

Some additional configuration may be required after librenms is deployed for the first time.

From the web UI run the validation script and it will tell us what to do.

1. Exec into the librenms-web pod

```
oc exec -it librenms-web-58bb567544-sczlm -- sh
```

2. Set the base_url (to whatever is in your route)

```
lnms config:set base_url https://librenms.apps.moc-infra.massopen.cloud
export SESSION_SECURE_COOKIE=true && lnms config:cache
```

3. Run the validate.php script from the container like

```
oc exec -it librenms-web-58bb567544-sczlm -- su - librenms -c "/opt/librenms/validate.php"
```

There should only be a warning about updates other than that everything should say "OK"

```
===========================================
Component | Version
--------- | -------
LibreNMS  | 26.2.0 (2026-02-16T08:14:20-05:00)
DB Schema | 2026_02_13_000000_change_stp_top_changes_to_unsigned_int (365)
PHP       | 8.3.29
Python    | 3.12.12
Database  | MariaDB 10.11.16-MariaDB-ubu2204
RRDTool   | 1.9.0
SNMP      | 5.9.4
===========================================

[OK]    Installed from package; no Composer required
[OK]    Database Connected
[OK]    Database Schema is current
[OK]    SQL Server meets minimum requirements
[OK]    lower_case_table_names is enabled
[OK]    MySQL engine is optimal
[OK]    Database and column collations are correct
[OK]    Database schema correct
[OK]    MySQL and PHP time match
[OK]    Active pollers found
[OK]    Dispatcher Service is enabled
[OK]    Locks are functional
[OK]    No python wrapper pollers found
[OK]    Redis is functional
[OK]    rrdtool version ok
[OK]    Connected to rrdcached
[WARN]  Non-git install, updates are manual or from package
```
