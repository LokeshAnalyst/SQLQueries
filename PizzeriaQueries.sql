--Dashboard 1
SELECT
	o.order_id,
	i.item_price,
	o.quantity,
	i.item_cat,
	i.item_name,
	o.created_at,
	a.delivery_address1,
	a.delivery_city,
	a.delivery_zipcode,
	o.delivery 
FROM
	orders as o
	LEFT JOIN item as i ON o.item_id = i.item_id
	LEFT JOIN address as a ON o.add_id = a.add_id

--Dashboard 2

SELECT
	s1.item_name AS item_name,
	s1.ing_name AS ing_name,
	s1.ing_id AS ing_id,
	s1.ing_weight AS ing_weight,
	s1.ing_price AS ing_price,
	s1.order_quantity AS order_quantity,
	s1.recipe_quantity AS recipe_quantity,(
		s1.order_quantity * s1.recipe_quantity 
		) AS ordered_weight,(
		s1.ing_price / s1.ing_weight 
		) AS unit_cost,((
			s1.order_quantity * s1.recipe_quantity 
		) * ( s1.ing_price / s1.ing_weight )) AS ingredient_cost 
FROM
	(
	SELECT
		o.item_id AS item_id,
		i.sku AS sku,
		i.item_name AS item_name,
		r.ing_id AS ing_id,
		ing.ing_name AS ing_name,
		ing.ing_weight AS ing_weight,
		ing.ing_price AS ing_price,
		sum( o.quantity ) AS order_quantity,
		r.quantity AS recipe_quantity 
	FROM
		(((
					orders as o
					LEFT JOIN item as i ON ((
							o.item_id = i.item_id 
						)))
				LEFT JOIN recipe as r ON ((
						i.sku = r.recipe_id 
					)))
			LEFT JOIN ingredient as ing ON ((
					ing.ing_id = r.ing_id 
				)))
	GROUP BY
		o.item_id,
		i.sku,
		i.item_name,
		r.ing_id,
		r.quantity,
		ing.ing_name,
		ing.ing_weight,
	ing.ing_price 
	) s1

select
s2.ing_name,
s2.ordered_weight,
ing.ing_weight,
inv.quantity,
ing.ing_weight * inv.quantity AS total_inv_weight 
FROM
	( SELECT ing_id, ing_name, sum( ordered_weight ) AS ordered_weight FROM stock1 GROUP BY ing_name, ing_id ) s2
	LEFT JOIN inventory as inv ON inv.item_id = s2.ing_id
	LEFT JOIN ingredient as ing ON ing.ing_id = s2.ing_id

--Note: Stock1 in this query is a view of the previous dashboard.
--Dashboard 3
SELECT
	r.date,
	s.first_name,
	s.last_name,
	s.hourly_rate,
	sh.start_time,
	sh.end_time,
	DATEDIFF(minute,sh.start_time,sh.end_time) as minutes_Worked

FROM
	rota as r
	LEFT JOIN staff as s ON r.staff_id = s.staff_id
	LEFT JOIN shift as sh ON r.shift_id = sh.shift_id
