view: inventory_items {
  sql_table_name: looker-private-demo.ecomm.inventory_items ;;

  dimension: id {
    label: "ID"
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: cost {
    label: "Cost"
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: product_brand {
    label: "Product Brand"
    type: string
    sql: ${TABLE}.product_brand ;;
  }

  dimension: product_category {
    label: "Product Category"
    type: string
    sql: ${TABLE}.product_category ;;
  }

  dimension: product_department {
    label: "Product Department"
    type: string
    sql: ${TABLE}.product_department ;;
  }

  dimension: product_distribution_center_id {
    label: "Product Distribution Center ID"
    type: number
    sql: ${TABLE}.product_distribution_center_id ;;
  }

  dimension: product_id {
    label: "Product ID"
    type: number
    sql: ${TABLE}.product_id ;;
  }

  dimension: product_name {
    label: "Product Name"
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: product_retail_price {
    label: "Product Retail Price"
    type: number
    sql: ${TABLE}.product_retail_price ;;
  }

  dimension: product_sku {
    label: "Product SKU"
    type: string
    sql: ${TABLE}.product_sku ;;
  }

  dimension_group: sold {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.sold_at ;;
  }

  measure: count {
    label: "Count"
    type: count
    drill_fields: [id, product_name]
  }
}
