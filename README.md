# AWS Athena Module

This module provides an easy way to set up Athena queries.

The module can set up Athena database and table from an input S3 bucket and create-table SQL script.

If database and tables are already provisioned (for instance by AWS Glue), the module can be used to define a set of Athena queries.

The module is not responsible for the creation / lifecycle of S3 buckets - it is recommended that these are created using the separate module 
responsible for creating encrypted private S3 buckets.

## Variables

| Name                          | Type    | Default | Required | Description                                                                
| ------------------------------| ------- | ------- | -------- | -------------------------------------------------------------------------- 
| create_database               | string  | true    |          | A boolean that indicates if a new Athena database should be created.                                      
| database_name                 | string  |         |          | Name of the existing database. Required if create_database variable is false                                       
| bucket_name                   | string  |         |          | Name of the Athena database bucket. Required if create_database is true                   
| database_force_destroy        | bool    | false   |          | A boolean that indicates all tables should be deleted from the database so that the database can be destroyed without error. The tables are not recoverable.
| create_table_sql_path         | string  |         |          | A path to the file that contains create table sql
| queries                       | map     |         | ✓        | A map of Athena query SQLs where key is the query name and the value is the path to the file containing the query
| query_output_locations        | map     |         |          | A map of output locations (S3 URLs) for Athena queries. Keys are query names identical to the map above. If omitted, output locations need to be specified in queries.
| query_output_buckets_kms_keys | map     |         |          | A map of KMS keys used to encrypt data in Athena queries output S3 buckets. Keys are query names identical to the map above. Results will not be encrypted if the key for a query is not defined in the map.
| query_template_parameters     | map     |         |          | A map of key value pairs used to customise Athena queries. These are typically environment/stage specific. If omitted, only available query template parameters will be db_name and env.
| namespace                     | string  |         | ✓        | Namespace used for labeling resources                  
| name                          | string  |         | ✓        | Name of the module / resources                         
| stage                         | string  |         | ✓        | What staga are the resources for? staging, production? 
| tags                          | map     |         | ✓        | Map of tags to be applied to all resources             

## Outputs

| Name                         | Description                                                       |
| ---------------------------- | ----------------------------------------------------------------- |
| database_name                | Name of the Athena database                                       |
| create_table_query_id        | Id of the create table query                                      |
| create_table_query_name      | Name of the create table query                                    |
| query_ids                    | A map of query names and ids                                      |

