view: adevents {
  view_label: "Ad Events"
  sql_table_name: looker-private-demo.ecomm.ad_events ;;

  dimension: adevent_id {
    label: "Ad Event ID"
    type: number
    primary_key: yes
    sql: ${TABLE}.id ;;
  }

  dimension: keyword_id {
    label: "Keyword ID"
    type: number
    sql: ${TABLE}.keyword_id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      hour_of_day,
      day_of_week,
      month,
      month_num,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  filter: previous_period_filter {
    type: date
    description: "Use this filter for period analysis"
  }

  dimension: previous_period {
    label: "Previous Period"
    type: string
    description: "The reporting period as selected by the Previous Period Filter"
    sql:
      {% if previous_period_filter._in_query %}
            CASE
              WHEN (${created_raw} >=  {% date_start previous_period_filter %}
                  AND ${created_raw}  <= {% date_end previous_period_filter %})
                THEN 'This Period'
              WHEN (date(${created_raw})  >= DATE_SUB(DATE_SUB(date({% date_start previous_period_filter %}), INTERVAL 1 DAY )
                                          , INTERVAL DATE_DIFF(date({% date_end previous_period_filter %}),
                                          date({% date_start previous_period_filter %}), DAY ) + 1 DAY)
                  AND date(${created_raw})  <= DATE_SUB(date({% date_start previous_period_filter %}), INTERVAL 1 DAY ))
                THEN 'Previous Period'
              ELSE NULL END
      {% else %} NULL {% endif %}
      ;;
  }

  dimension: device_type {
    label: "Device Type"
    type: string
    sql: ${TABLE}.device_type ;;
  }

  dimension: event_type {
    label: "Event Type"
    type: string
    sql: ${TABLE}.event_type ;;
  }

  dimension: is_click_event {
    label: "Is Click Event"
    type: yesno
    sql: ${event_type} = 'click';;
  }
  dimension: is_impression_event {
    label: "Is Impression Event"
    type: yesno
    sql: ${event_type} = 'impression';;
  }

  dimension: cost_search{
    label: "Cost Search"
    hidden: yes
    type: number
    sql: case when ${is_click_event} = true
        and ${campaigns.advertising_channel} = 'Search' then (1.0*${TABLE}.amount)/100 end ;;
    value_format_name: usd
  }

  dimension: cost_display{
    label: "Cost Display"
    hidden: yes
    type: number
    sql: case when ${is_impression_event} = true
      and ${campaigns.advertising_channel} != 'Search'
      then (1.0*${TABLE}.amount)/1000 end ;;
    value_format_name: usd
  }

  dimension: cost {
    label: "Cost"
    type: number
    hidden: yes
    sql: ${cost_search} + ${cost_display} ;;
    value_format_name: usd
  }

##### Campaign Standard Metric Aggregates #####

  measure: total_cost_clicks {
    hidden: yes
    label: "Total Spend (Search Clicks)"
    type: sum
    sql: ${cost_search} ;;
    value_format_name: usd
  }

  measure: total_cost_impressions {
    hidden: yes
    label: "Total Spend (Display Impressions)"
    type: sum
    sql: ${cost_display} ;;
    value_format_name: usd
  }

  measure: total_cost {
    label: "Total Spend"
    type: number
    sql: ${total_cost_clicks} + ${total_cost_impressions} ;;
    value_format_name: usd
    drill_fields: [detail*]
  }

  measure: total_cumulative_spend {
    label: "Total Spend (Cumulative)"
    type: running_total
    sql: ${total_cost_clicks} ;;
    value_format_name: usd_0
    drill_fields: [campaign_detail*]

  }
##### Ad Event Metrics #####

  measure: total_ad_events {
    label: "Total Ad Events"
    type: count
    drill_fields: [events.id, keywords.criterion_name, keywords.keyword_id]
  }

  measure: total_clicks {
    label: "Total Clicks"
    type: sum
    sql: case when ${event_type} = 'click' then 1 else 0 end;;
    drill_fields: [detail*]
  }

  measure: total_impressions {
    label: "Total Impressions"
    type: sum
    sql: case when ${event_type} = 'impression' then 1 else 0 end;;
    drill_fields: [detail*]
  }

##### Viewability & Conversion Metrics #####

  measure: total_viewability {
    label: "Total Viewability"
    type: number
    sql: ${total_impressions} * .66 ;;
    value_format_name: decimal_0
    drill_fields: [detail*]

  }

  measure: click_rate {
    label: "Click Through Rate (CTR)"
    description: "Percent of people that click on an ad."
    type: number
    sql: ${total_clicks}*1.0/nullif(${total_impressions},0) ;;
    value_format_name: percent_2
    drill_fields: [detail*]

  }

  measure: cost_per_click {
    label: "Cost per Click (CPC)"
    description: "Average cost per ad click."
    type: number
    sql: ${total_cost_clicks}* 1.0/ NULLIF(${total_clicks},0) ;;
    value_format_name: usd
    drill_fields: [detail*]
  }

  measure: cost_per_impression {
    label: "Cost per Thousand Impressions (CPM)"
    description: "Average cost per one thousand ad impressions for display ads."
    type: number
    sql: ${total_cost_impressions}* 1.0/ NULLIF(1.0*${total_impressions}/1000,0) ;;
    value_format: "$0.000"
    drill_fields: [detail*]
  }

  set: detail {
    fields: [campaigns.campaign_name, keywords.criterion_name, device_type, event_type, total_cost]

  }
  set: campaign_detail {
    fields: [campaigns.campaign_name, adgroups.name, adgroups.ad_type, total_cost]
  }
}
