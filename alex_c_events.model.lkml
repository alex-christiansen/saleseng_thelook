connection: "thelook_events"

# include: "*.views.lkml"
include: "views/*.view"
label: "1) Event Data - Alex"
# include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
# explore: order_items {
#   join: orders {
#     relationship: many_to_one
#     sql_on: ${orders.id} = ${order_items.order_id} ;;
#   }
#
#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
# }
#
datagroup: orders_datagroup {
#   sql_trigger: SELECT max(created_time) FROM order_items ;;
  max_cache_age: "4 hours"
}
# Using Looker references

explore: order_items {
  label: "Order Items"
  sql_always_where: ${created_date} >= '2019-01-01' ;;

  join: inventory_items {
    fields: [cost, created_date*, product_brand, product_category, product_department, product_name, product_retail_price, sold_date*, count]
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    type: left_outer
    relationship: one_to_one
  }

  join: users {
    sql_on: ${users.id} = ${order_items.user_id} ;;
    type: left_outer
    relationship: many_to_one
  }

}

explore: distribution_centers {
  label: "Distribution Centers"
  persist_with: orders_datagroup

  join: products {
    sql: ${distribution_centers.id} = ${products.distribution_center_id} ;;
    type: left_outer
    relationship: one_to_many
  }
}

explore: events {
  label: "User Events"

  always_filter: {
    filters: {
      field: state
      value: "WA, OR, CA, NM, AZ, CO, MT, ID, NV, UT, WY"
    }
  }

  join: users {
    sql: ${events.user_id} = ${users.id} ;;
    type: left_outer
    relationship: many_to_one
  }

  join: order_items {
    sql: ${events.user_id} = ${order_items.user_id} ;;
    type: left_outer
    relationship: one_to_many
  }
}
