# Olist Marketplace db

Реляционная база данных на основе публичного датасета [Olist Brazilian E-Commerce](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

## Структура репозитория

| Файл | Описание |
|---|---|
| `marketplace.sql` | Схема БД - создание таблиц и индексов |
| `load_data.sql` | Загрузка данных из CSV |
| `queries.sql` | SQL-запросы |

## Схема

8 таблиц:

- `customers` — покупатели
- `sellers` — продавцы
- `categories` — справочник категорий товаров
- `products` — товары
- `orders` — заказы
- `order_items` — позиции заказов
- `order_payments` — платежи
- `order_reviews` — отзывы покупателей

## Запросы

В `queries.sql`:

- статистика по статусам заказов и способам оплаты
- топ продавцов по выручке
- категории товаров с оценкой выше средней
- среднее время доставки по штатам
- ранжирование продавцов внутри штата

## Как запустить

1. Скачать датасет: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce
2. Положить CSV-файлы в папку `data/`
3. Перейти в корень репозитория и выполнить:

```bash
psql -U postgres -f marketplace.sql
psql -U postgres -d marketplace -f load_data.sql
```
