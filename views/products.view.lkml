view: products {
  sql_table_name: `looker-private-demo.ecomm.products`
    ;;
  drill_fields: [id]

  dimension: id {
    label: "ID"
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: brand {
    label: "Brand"
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: category {
    label: "Category"
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: cost {
    label: "Cost"
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension: department {
    label: "Department"
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: distribution_center_id {
    label: "Distribution Center ID"
    type: string
    sql: ${TABLE}.distribution_center_id ;;
  }

  dimension: name {
    label: "Name"
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: retail_price {
    label: "Retail Price"
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    label: "SKU"
    type: string
    sql: ${TABLE}.sku ;;
  }

  measure: count {
    label: "Count"
    type: count
    drill_fields: [id, name]
  }
}
