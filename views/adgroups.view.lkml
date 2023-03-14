view: adgroups {
  view_label: "Ad Groups"
  sql_table_name: looker-private-demo.ecomm.ad_groups ;;

  dimension: ad_id {
    label: "Ad ID"
    primary_key: yes
    type: number
    sql: ${TABLE}.ad_id ;;
  }

  dimension: ad_type {
    label: "Ad Type"
    type: string
    sql: ${TABLE}.ad_type ;;
  }

  dimension: campaign_id {
    label: "Campaign ID"
    type: number
    hidden: yes
    sql: ${TABLE}.campaign_id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.created_at ;;
  }

  dimension: headline {
    label: "Headline"
    type: string
    sql: ${TABLE}.headline ;;
  }

  dimension: name {
    label: "Name"
    link: {
      label: "View on AdWords"
      icon_url: "https://www.google.com/s2/favicons?domain=www.adwords.google.com"
      url: "https://adwords.google.com/aw/ads?campaignId={{ campaign_id._value }}&adGroupId={{ ad_id._value }}"
    }
    link: {
      label: "Pause Ad Group"
      icon_url: "https://www.google.com/s2/favicons?domain=www.adwords.google.com"
      url: "https://adwords.google.com/aw/ads?campaignId={{ campaign_id._value }}&adGroupId={{ ad_id._value }}"
    }
    link: {
      url: "https://adwords.google.com/aw/ads?campaignId={{ campaign_id._value }}&adGroupId={{ ad_id._value }}"
      icon_url: "https://www.gstatic.com/awn/awsm/brt/awn_awsm_20171108_RC00/aw_blend/favicon.ico"
      label: "Change Bid"
    }
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: period {
    label: "Period"
    type: number
    sql: ${TABLE}.period ;;
  }

  measure: count {
    label: "Count"
    type: count
    drill_fields: [campaigns.campaign_name, name, ad_type, created_date]
  }
}
