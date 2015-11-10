create temp table sizes as
SELECT
    table_name,
    table_size AS table_size,
    indexes_size AS indexes_size

FROM (
    SELECT
        table_name,
        pg_table_size(table_name) AS table_size,
        pg_indexes_size(table_name) AS indexes_size

    FROM (
        SELECT ('"' || table_schema || '"."' || table_name || '"') AS table_name
        FROM information_schema.tables
    ) AS all_tables
--    ORDER BY total_size DESC
) AS pretty_sizes;
SELECT sizes.table_size AS state,COALESCE(count,0) FROM
                 (VALUES ('active'),('waiting'),('idle'),('idletransaction'),('unknown')) AS tmp(mstate)
                LEFT JOIN
                 (
select table_size, index_size from (select sum(table_size) as table_size, sum(indexes_size) as index_size from sizes) as saraza;

/*
    SELECT
        table_name,
        pg_table_size(table_name) AS table_size,
        pg_indexes_size(table_name) AS indexes_size,
        pg_total_relation_size(table_name) AS total_size
    FROM (
        SELECT ('"' || table_schema || '"."' || table_name || '"') AS table_name
        FROM information_schema.tables
    ) AS all_tables;
*/
/*
SELECT ('"' || table_schema || '"."' || table_name || '"') AS table_name
        FROM information_schema.tables;
*/
