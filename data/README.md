# Данные

Проект использует CSV-снимок публичного синтетического набора `bigquery-public-data.thelook_ecommerce`.

Таблицы:

- `users`;
- `orders`;
- `order_items`;
- `products`;
- `events`;
- `inventory_items`;
- `distribution_centers`.

Локальные CSV хранятся в `data/raw/` и исключены из Git, потому что воспроизводимо создаются при первом запуске ноутбука Pandas.

Для SQL-анализа `sql/00_setup.sql` копирует одноимённые публичные таблицы в собственную схему BigQuery. Локальный снимок Pandas зафиксирован на версии зеркала Kaggle 1 от 28.07.2022.
