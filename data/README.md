# Данные

Проект использует CSV snapshot публичного синтетического датасета `bigquery-public-data.thelook_ecommerce`.

Таблицы:

- `users`
- `orders`
- `order_items`
- `products`
- `events`
- `inventory_items`
- `distribution_centers`

Локальные CSV хранятся в `data/raw/` и исключены из Git, потому что воспроизводимо создаются первым запуском Pandas-notebook.

Для SQL-анализа `sql/00_setup.sql` копирует одноимённые публичные таблицы в собственную схему BigQuery. Локальный Pandas snapshot зафиксирован на версии Kaggle mirror 1 от 28.07.2022.
