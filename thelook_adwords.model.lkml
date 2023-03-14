label: "Digital Marketing"

connection: "looker-private-demo"

include: "*/*.view.lkml"         # include all views in this project
include: "dashboards/*.dashboard.lookml"  # include all dashboards in this project


datagroup: ecommerce_etl {
  sql_trigger: SELECT max(id) FROM looker-private-demo.ecomm.events ;;
  max_cache_age: "24 hours"}
persist_with: ecommerce_etl

explore: events{
  label:  "(1) Digital Ads - Event Data"
  join: sessions {
    view_label: "Sessions"
    relationship: many_to_one
    sql_on: ${events.session_id} = ${sessions.session_id} ;;
  }
  join: products {
    view_label: "Products"
    relationship: many_to_one
    sql_on: ${products.id}=cast(${events.viewed_product_id} as int64) ;;
  }
  join: users {
    view_label: "Users"
    relationship: many_to_one
    sql_on: ${sessions.session_user_id} = ${users.id} ;;
    fields: [user_facts*]
  }
  join: user_session_fact {
    view_label: "Users"
    relationship: one_to_one
    sql_on: ${users.id} = ${user_session_fact.session_user_id} ;;
  }

  join: session_purchase_facts {
    view_label: "Session Purchase Facts"
    relationship: many_to_one
    sql_on: ${sessions.session_user_id} = ${session_purchase_facts.session_user_id}
          and ${sessions.session_start_raw} >= ${session_purchase_facts.last_session_end_raw}
          and ${sessions.session_end_raw} <= ${session_purchase_facts.session_end_raw};;
  }

  join: adevents {
    view_label: "Adevents"
    relationship: one_to_many
    sql_on: ${events.ad_event_id} = ${adevents.adevent_id}
      and ${events.referrer_code} = ${adevents.keyword_id}
      and ${events.is_entry_event}
      ;;
  }
  join: keywords {
    view_label: "Keywords"
    relationship: many_to_one
    sql_on:${keywords.keyword_id} = ${adevents.keyword_id} ;;
  }
  join: adgroups{
    view_label: "Adgroups"
    relationship: many_to_one
    sql_on: ${keywords.ad_id} = ${adgroups.ad_id} ;;
  }
  join: campaigns {
    view_label: "Campaigns"
    relationship: many_to_one
    sql_on: ${campaigns.campaign_id} = ${adgroups.campaign_id} ;;
    type: full_outer
  }
}



explore: sessions{
  fields: [ALL_FIELDS*, -sessions.funnel_view*]
  label: "(2) Marketing Attribution"
  join: adevents {
    relationship: many_to_one
    sql_on: ${adevents.adevent_id} = ${sessions.ad_event_id} ;;
  }
  join: users {
    view_label: "Users"
    relationship: many_to_one
    sql_on: ${sessions.session_user_id} = ${users.id} ;;
    fields: [user_facts*]
  }
  join: user_session_fact {
    view_label: "Users"
    relationship: one_to_one
    sql_on: ${users.id} = ${user_session_fact.session_user_id} ;;
  }

  join: session_attribution {
    view_label: "Session Attribution"
    relationship: many_to_one
    sql_on: ${sessions.session_user_id} = ${session_attribution.session_user_id}
          and ${sessions.session_start_raw} >= ${session_attribution.last_session_end_raw}
          and ${sessions.session_end_raw} <= ${session_attribution.session_end_raw};;
    fields: [attribution_detail*]
  }
  join: keywords {
    view_label: "Keywords"
    relationship: many_to_one
    sql_on:${keywords.keyword_id} = ${adevents.keyword_id} ;;
  }
  join: adgroups{
    view_label: "Adgroups"
    relationship: many_to_one
    sql_on: ${keywords.ad_id} = ${adgroups.ad_id} ;;
  }
  join: campaigns {
    view_label: "Campaigns"
    relationship: many_to_one
    sql_on: ${campaigns.campaign_id} = ${adgroups.campaign_id} ;;
  }
}
