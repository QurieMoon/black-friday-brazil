-- 매년 블랙 프라이데이에 매출 변화를 시각적으로 살펴보기
-- 대상 년수: 2016, 2017, 2018 총 3년
SELECT DATE_FORMAT(order_purchase_timestamp, '%Y-%m-%d') AS 'mdy_order_purchase_timestamp'
     , COUNT(DISTINCT order_id) AS cnt_orders
     , COUNT(DISTINCT customer_id) AS cnt_custmoers
FROM olist_orders_dataset
GROUP BY mdy_order_purchase_timestamp
ORDER BY mdy_order_purchase_timestamp ASC
LIMIT 10;

-- 2017년 데이터로 블랙 프라이데이에 매출 변화 여부를 시각적으로 확인하기 (주문 수)
SELECT DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS 'order_purchase_year_month'
     , COUNT(DISTINCT order_id) AS cnt_orders
FROM olist_orders_dataset
WHERE olist_orders_dataset.order_purchase_timestamp BETWEEN '2017-01-01 00:00:00' AND '2017-12-31 23:59:59'
GROUP BY order_purchase_year_month
ORDER BY order_purchase_year_month ASC;

-- 2017년 데이터로 블랙 프라이데이에 매출 변화 여부를 시각적으로 확인하기 (결제 금액)
-- 할부 처리 관련 내용은 포트폴리오 참고!
SELECT DATE_FORMAT(olist_orders_dataset.order_purchase_timestamp, '%Y-%m') AS 'order_purchase_year_month'
     , ROUND(SUM(olist_order_payments_dataset.payment_value), 2) AS total_payments
FROM olist_orders_dataset
    INNER JOIN olist_order_payments_dataset ON olist_orders_dataset.order_id = olist_order_payments_dataset.order_id
WHERE olist_orders_dataset.order_purchase_timestamp BETWEEN '2017-01-01 00:00:00' AND '2017-12-31 23:59:59'
GROUP BY order_purchase_year_month
ORDER BY order_purchase_year_month ASC;

