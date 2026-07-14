
### Подтверждённые результаты Pandas-анализа

1. Net Revenue Proxy = **$8,067,639**, Gross Profit Proxy = **$4,185,726**, margin = **51.9%**.
2. Return Rate = **11.8%**, Cancellation Rate = **15.0%**.
3. Repeat Purchase Rate = **30.4%**; M1 retention = **5.1%**, M3 = **3.9%**.
4. Session purchase conversion = **26.6%**.
5. Сегмент **Champions** создаёт **25.9%** Net Revenue при доле клиентов **12.3%**.
6. Категория **Plus** имеет Item Return Rate **12.8%**.
7. Наибольший aged inventory risk — **Houston TX: $1,006,420**.
8. Решение по A/B-симуляции — **PILOT: конверсия выросла, экономика не ухудшилась в симуляции**.

### Рекомендации

| Приоритет | Действие | KPI |
|---|---|---|
| P0 | Мониторить Net Revenue, Margin, Return и Cancellation вместо одного GMV | Net Revenue, Margin |
| P1 | Запустить CRM-сценарий второй покупки в первые 30 дней | M1 retention |
| P1 | Диагностировать размерные сетки и карточки рискованных категорий | Item Return Rate |
| P1 | Реактивировать At Risk / High Value At Risk без скидки всем клиентам | Incremental profit |
| P2 | Снизить aged stock в Houston TX | Aged inventory cost |
| P2 | Бесплатную доставку запускать только при положительном profit guardrail | Contribution/User |

### Ограничения

- Датасет и A/B-тест синтетические.
- Нет маркетинговых затрат, налогов, платежей, поддержки и NPS.
- Последний месяц неполный; правый край когорт цензурирован.
- Наблюдательные связи не являются причинными эффектами.
