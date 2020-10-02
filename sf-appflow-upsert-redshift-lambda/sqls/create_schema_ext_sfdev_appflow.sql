/* Create external schema using Spectrum from the pre-defined Glue Catalog */
/* Replace XXXXXXXXXXXX with an actual AWS account number */
create external schema ext_sfdev_appflow
from data catalog
database 'sfdev-appflow'
iam_role 'arn:aws:iam::XXXXXXXXXXXX:role/sfdev-appflow-redshift'
create external database if not exists;