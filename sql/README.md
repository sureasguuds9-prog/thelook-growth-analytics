# SQL-слой: BigQuery Sandbox

SQL вынесен из Python-notebook и выполняется отдельно в BigQuery. `00_setup.sql` копирует семь публичных таблиц TheLook в вашу собственную схему `thelook_portfolio`. Это даёт отдельное SQL-хранилище без ручной загрузки 500+ МБ CSV через браузер.

## Как запустить

1. Откройте BigQuery Sandbox: <https://console.cloud.google.com/bigquery>.
2. Создайте бесплатный Google Cloud project, если его ещё нет.
3. Во всех `.sql` файлах замените `your-gcp-project-id` на ID своего проекта.
4. Запускайте запросы по порядку:

```text
00_setup.sql
01_data_quality.sql
02_order_mart.sql
03_executive_kpi.sql
04_monthly_metrics.sql
05_funnel.sql
06_retention.sql
07_rfm.sql
08_product_operations.sql
09_validation.sql
```

`00_setup.sql` загружает исходные таблицы в вашу схему. `02_order_mart.sql` создаёт аналитическую таблицу с гранулярностью «одна строка = один заказ». Остальные запросы читают вашу копию данных и эту витрину.

## Архитектура

```text
bigquery-public-data.thelook_ecommerce.*
                    │
                    ▼
your-gcp-project-id.thelook_portfolio.{source tables}
                    │
                    ▼
your-gcp-project-id.thelook_portfolio.order_mart
                    │
       ┌────────────┼────────────┐
       ▼            ▼            ▼
      KPI       Retention       RFM / Ops
```

Определения метрик совпадают с Pandas-notebook, поэтому результаты можно использовать для перекрёстной проверки.
