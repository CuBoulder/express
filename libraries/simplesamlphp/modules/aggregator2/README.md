Aggregator 2
============

This is a SimpleSAMLphp module for metadata aggregation. It is designed to preserve most of the common
metadata items, and it also attempts to preserve unknown elements. Metadata sources are parsed and rebuilt,
so small differences between the original sources and the metadata generated may occur. More specifically:

* Signatures will be removed from every signed metadata source.
* All sources will be wrapped up in an EntitiesDescriptor element.

Note: This aggregator works only with XML metadata, and does its work independently of other parts of
SimpleSAMLphp, such as the metarefresh module.

Installation
------------

Once you have installed SimpleSAMLphp, installing this module is very simple. Just execute the following
command in the root of your SimpleSAMLphp installation:

```
composer.phar require simplesamlphp/simplesamlphp-module-aggregator2:dev-master
```

where `dev-master` instructs Composer to install the `master` branch from the Git repository. See the
[releases](https://github.com/simplesamlphp/simplesamlphp-module-aggregator2/releases) available if you
want to use a stable version of the module.

Configuration
-------------

This module is configured through the `config/module_aggregator2.php` configuration file.
An example file is available in `modules/aggregator2/config-templates/`:

    cp modules/aggregator2/config-templates/module_aggregator2.php config/

The configuration file contains one or more aggregators in the configuration array.
The index for each item in the configuration array gives the identifier of the aggregator.


### Aggregator entry configuration

The aggregator can be configured with the following options:

* `sources`:   Array which describes a source from which we should download metadata.

* `cron.tag`:   Can be used to run periodical updates. It will only be useful when you have metadata caching enabled.

* `cache.directory`:   The path to a directory where the aggregator will cache downloaded and generated metadata.
    This directory must be writable by the web server.

* `cache.generated`:   The number of seconds the generated metadata will be cached for.

    *Note*: generated metadata will not be cached if this option is unset.

* `valid.length`:   The number of seconds the generated metadata should be valid for.
    This is used to set the `validUntil` attribute on the generated metadata. Defaults to one week.

    *Note*: The value of the `cache.generated` option must be smaller than the value here, otherwise you would end up
returning outdated metadata.

* `ssl.cafile`:   This option enables validation of the server certificate when fetching metadata over HTTPS. It must be a path
pointing to a PEM file which contains one or more valid CA certificates. The path can be either absolute or relative to the `cert` directory.

    *Note*: This option can be overridden for each metadata source.

* `sign.privatekey`:   The private key that should be used to sign the resulting metadata, in PEM format. The path to the private key can
be either absolute or relative to the `cert` directory. Skip this option or set it to `NULL` if you don't want to sign the generated metadata.

* `sign.privatekey_pass`:   The password used to encrypt the private key. If this option is unset, the private key is assumed to be unencrypted.

* `sign.certificate`:   The certificate that contains the public key corresponding to the private key, in PEM format. The path to the
certificate can be either absolute or relative to the `cert` directory.

    *Note*: This certificate will be included in the generated metadata.

* `sign.algorithm`:   The algorithm that should be used to sign the resulting metadata. The following algorithms are supported:

    * `http://www.w3.org/2000/09/xmldsig#rsa-sha1`

    * `http://www.w3.org/2001/04/xmldsig-more#rsa-sha256`

    * `http://www.w3.org/2001/04/xmldsig-more#rsa-sha384`

    * `http://www.w3.org/2001/04/xmldsig-more#rsa-sha512`

    *Note*: this option defaults to `http://www.w3.org/2000/09/xmldsig#rsa-sha1` for backwards compatibility. However, it is
    recommended to use another algorithm as SHA1 is considered broken.

* `RegistrationInfo`:   Allows to specify information about the registrar of the generated metadata. Please refer to the
[MDRPI extension](https://simplesamlphp.org/docs/stable/simplesamlphp-metadata-extensions-rpi) document for further information.

* `exclude`:   Allows to exclude one or more entities from the generated metadata, represented by their entity IDs. Can be either
a string with the entity ID of a single entity, or an array of strings with all the entity IDs to exclude from the result.

    *Note*: this option will not exclude the entities from the cached metadata sources. It will only act as a default
configuration for the generation of the metadata aggregate, and therefore can be overridden per request.

* `filter`:   One or more sets representing the types of entities that should be included in the generated metadata. Filtering
will be performed depending on the role of the entity, as well as the protocols it supports. Can be either a string
with the set of entities desired, or an array of strings with all the different sets to filter by. The following
sets are available:

    * `saml2`: all the entities that support the SAML 2.0 protocol.

    * `shib13`: all the entities that support the SAML 1.1 protocol.

    * `saml20-idp`: all the identity providers that support the SAML 2.0 protocol.

    * `saml20-sp`: all the service providers that support the SAML 2.0 protocol.

    * `saml20-aa`: all the attribute authorities that support the SAML 2.0 protocol.

    * `shib13-idp`: all the identity providers that support the SAML 1.1 protocol.

    * `shib13-sp`: all the service providers that support the SAML 1.1 protocol.

    * `shib13-aa`: all the attribute authorities that support the SAML 1.1 protocol.

    *Note*: this option will not filter the entities in the cached metadata sources. It will only act as a default
configuration for the generation of the metadata aggregate, and therefore can be overriden per request.


### Aggregator source configuration

* `url`:   The URL the metadata should be fetched from.

* `ssl.cafile`:   This option enables validation of the server certificate when fetching metadata over HTTPS. It must be a path
pointing to a PEM file which contains one or more valid CA certificates. The path can be either absolute or relative to the `cert` directory.

    *Note*: This option overrides the option with the same name in the root configuration for the an aggregator.

* `cert`:   The certificate that should be used to check the signature of this metadata document, in PEM format. The path to
the certificate can be either absolute or relative to the `cert` directory.

    *Note*: This cannot be a CA certificate. Validation against CA certificates (PKI) is not supported.


Retrieving aggregated metadata
------------------------------

You will find a link to the aggregator2 module in the *Federation* tab of SimpleSAMLphp's web interface. There you will
be able to see a list of all the metadata aggregates you have configured, and see or download them in different
formats.

In general, metadata aggregates can be downloaded from the following location:

    http://<YOUR HOST>/simplesaml/modules.php/aggregator2/get.php?id=<aggregator id>

where the *aggregator id* is the identifier you used as an index for the aggregator configuration array. Additionally,
you can use the following parameters to customize the resulting metadata aggregate:

* `exclude`:   Allows to exclude one or more entities from the generated metadata, represented by their entity IDs. If you need to
specify more than one entity, use a comma-separated list of entity IDs.

* `filter`:   Allows to filter by sets specifying the type of entities or the protocols they support. If you need to specify more
than one set, use a comma-separated list. See the configuration option with the same name to get a list of all the sets supported.


Asynchronous metadata updates
-----------------------------

By default, the `aggregator2` module will update the metadata upon receiving a request. For performance reasons, it is
recommended to run the updates asynchronously. By doing this, the aggregated metadata will be generated in the
background.

To enable this, you must configure a cache directory with the `cache.directory` option. This directory must be writable
by the web server. You can then enable caching of generated metadata by setting the `cache.generated` option to the
number of seconds the metadata should be cached.

You will now have a configuration that caches both downloaded and generated metadata. However, it will still update the
metadata when the user accesses the aggregator endpoint. To update the generated metadata in the background, you must
add a `cron.tag` option. This option must reference a cron tag entry configured in `module_cron.php`. Once this is
done, your aggregated metadata will be updated every time that cron entry is executed.

