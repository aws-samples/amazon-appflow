/* Create target table */
create table tgt_sfdev_appflow.account(
id varchar,
isdeleted boolean,
name varchar,
type varchar,
billingstreet varchar,
billingcity varchar,
billingstate varchar,
billingpostalcode integer,
billingcountry varchar,
phone varchar,
fax varchar,
accountnumber varchar,
website varchar,
industry varchar,
tickersymbol varchar,
description varchar,
rating varchar,
createddate timestamp,
lastmodifieddate timestamp
);

create table stg_sfdev_appflow.account (like tgt_sfdev_appflow.account);