view: order_items {
  sql_table_name: looker-private-demo.ecomm.order_items ;;

  dimension: id {
    label: "ID"
    primary_key: yes
    type: number
    sql: ${TABLE}.ID ;;
  }

  dimension_group: created {
    #X# group_label:"Order Date"
    type: time
    timeframes: [time, hour, date, week, month, year, hour_of_day, day_of_week, month_num, raw, week_of_year]
    sql: ${TABLE}.CREATED_AT ;;
  }

  dimension: delivered_at {
    type: string
    sql: ${TABLE}.DELIVERED_AT ;;
  }

  dimension: inventory_item_id {
    label: "Inventory Item ID"
    type: number
    sql: ${TABLE}.INVENTORY_ITEM_ID ;;
  }

  dimension: order_id {
    label: "Order ID"
    type: number
    sql: ${TABLE}.ORDER_ID ;;
  }

  dimension: returned_at {
    label: "Returned At"
    type: string
    sql: ${TABLE}.RETURNED_AT ;;
  }

  dimension: sale_price {
    label: "Sale Price"
    type: number
    sql: ${TABLE}.SALE_PRICE ;;
  }

  dimension: shipped_at {
    label: "Shipped At"
    type: string
    sql: ${TABLE}.SHIPPED_AT ;;
  }

  dimension: status {
    label: "Status"
    type: string
    sql: ${TABLE}.STATUS ;;
  }

  dimension: user_id {
    label: "User ID"
    type: number
    sql: ${TABLE}.USER_ID ;;
  }

  measure: total_sale_price {
    label: "Total Sale Price"
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd_0
  }

  measure: count {
    label: "Count"
    type: count
    drill_fields: [id]
  }
}
