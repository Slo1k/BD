-- Ustawienie parametrów
SET hivevar:input_dir3='/ścieżka/do/input_dir3';
SET hivevar:input_dir4='/ścieżka/do/input_dir4';
SET hivevar:output_dir6='/ścieżka/do/output_dir6';

-- Wczytanie danych z wyniku zadania MapReduce
CREATE EXTERNAL TABLE IF NOT EXISTS temp_table
(
    developer_id_year STRING,
    ratings_sum FLOAT,
    ratings_count INT,
    apps_count INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LOCATION '${hivevar:input_dir3}';

-- Wczytanie danych z datasource4
CREATE EXTERNAL TABLE IF NOT EXISTS developers
(
    developer_id STRING,
    developer_name STRING,
    developer_website STRING,
    developer_email STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LOCATION '${hivevar:input_dir4}';

-- Przetwarzanie danych i zapisanie wyniku do output_dir6
INSERT OVERWRITE DIRECTORY '${hivevar:output_dir6}'
SELECT
    d.developer_name AS developer_name,
    SUBSTR(tt.developer_id_year, -4) AS year,
    tt.ratings_sum / tt.ratings_count AS avg_rate,
    tt.apps_count AS count_apps,
    tt.ratings_count AS count_rates
FROM
    temp_table tt
JOIN
    developers d
ON
    tt.developer_id_year LIKE CONCAT('%', d.developer_id, '-%')
WHERE
    tt.ratings_count >= 1000
ORDER BY
    SUBSTR(tt.developer_id_year, -4) ASC, avg_rate DESC
LIMIT 3;