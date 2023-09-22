-- SELECT COUNT(DISTINCT order_id) -- 99441
-- FROM olist_orders_dataset

-- SELECT COUNT(DISTINCT customer_id) -- 99441
-- FROM olist_orders_dataset

-- RFM
WITH monetary_ref_tbl AS (
  SELECT SUM(olist_order_payments_dataset.payment_value) AS sum_payments
  FROM olist_orders_dataset
       INNER JOIN olist_order_payments_dataset ON olist_orders_dataset.order_id = olist_order_payments_dataset.order_id
  WHERE olist_orders_dataset.order_purchase_timestamp BETWEEN '2017-10-01 00:00:00' AND '2017-10-31 23:59:59'
  GROUP BY olist_orders_dataset.customer_id
  ORDER BY sum_payments ASC
), olist_customers_rfm_tbl AS (
  SELECT olist_orders_dataset.customer_id
       , CASE
            WHEN  COUNT(DISTINCT CASE WHEN olist_orders_dataset.order_purchase_timestamp BETWEEN '2017-10-01 00:00:00' AND '2017-10-31 23:59:59' THEN olist_orders_dataset.order_id END) >= 1 THEN 'recent'
            WHEN  COUNT(DISTINCT CASE WHEN olist_orders_dataset.order_purchase_timestamp < '2017-10-01 00:00:00'  THEN olist_orders_dataset.order_id END) >= 1 THEN 'past'
            ELSE 'future'
         END AS recency
      --  , CASE
      --       WHEN COUNT(DISTINCT order_id) <= (SELECT COUNT(DISTINCT order_id) AS cnt_orders FROM olist_orders_dataset GROUP BY customer_id ORDER BY cnt_orders LIMIT 24861, 1) THEN 'low'
      --       WHEN COUNT(DISTINCT order_id) <= (SELECT COUNT(DISTINCT order_id) AS cnt_orders FROM olist_orders_dataset GROUP BY customer_id ORDER BY cnt_orders LIMIT 49721, 1) THEN 'medium'
      --       ELSE 'high'
      --    END AS frequency
       , CASE
            WHEN SUM(CASE WHEN olist_orders_dataset.order_purchase_timestamp BETWEEN '2017-10-01 00:00:00' AND '2017-10-31 23:59:59' THEN olist_order_payments_dataset.payment_value ELSE 0 END) <= (SELECT sum_payments FROM monetary_ref_tbl LIMIT 1157, 1) THEN 'low'
            WHEN SUM(CASE WHEN olist_orders_dataset.order_purchase_timestamp BETWEEN '2017-10-01 00:00:00' AND '2017-10-31 23:59:59' THEN olist_order_payments_dataset.payment_value ELSE 0 END) <= (SELECT sum_payments FROM monetary_ref_tbl LIMIT 3473, 1) THEN 'medium'
            ELSE 'high'
         END AS monetary
  FROM olist_orders_dataset
       INNER JOIN olist_order_payments_dataset ON olist_orders_dataset.order_id = olist_order_payments_dataset.order_id
  GROUP BY olist_orders_dataset.customer_id
)

SELECT recency
     , monetary
     , COUNT(DISTINCT customer_id) AS num_customers
FROM olist_customers_rfm_tbl
GROUP BY recency, monetary
ORDER BY FIELD(recency, 'recent', 'past'), FIELD(monetary, 'high', 'medium', 'low')

-- SELECT COUNT(DISTINCT customer_id)
-- FROM olist_orders_dataset --99441
-- WHERE order_purchase_timestamp BETWEEN '2017-10-01 00:00:00' AND '2017-10-31 23:59:59' -- 4631

-- SELECT *
-- FROM olist_closed_deals_dataset
-- LIMIT 1,1; -- 2

