# Marketplace Database

Реляционная база данных на основе датасета [Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).

Проектирование схем и написание  SQL запросов

## Схема

8 таблиц:

- `customers` — покупатели с привязкой к геолокации
- `sellers` — продавцы
- `categories` — справочник категорий товаров
- `products` — товары
- `orders` — заказы
- `order_items` — позиции заказов
- `order_payments` — платежи
- `order_reviews` — отзывы покупателей


## Как запустить

1. Скачать датасет: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce
2. Положить CSV-файлы в папку `data/`
3. Перейти в корень репозитория и выполнить:

```bash
psql -U postgres -f marketplace.sql
psql -U postgres -d marketplace -f load_data.sql
```
