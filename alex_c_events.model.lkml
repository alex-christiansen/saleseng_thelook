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
# datagroup: orders_datagroup {
#   sql_trigger: SELECT max(id) FROM my_tablename ;;
#   max_cache_age: "24 hours"
# }
#
# datagroup: customers_datagroup {
#   sql_trigger: SELECT max(id) FROM my_other_tablename ;;
# }
#
# persist_with: orders_datagroup
#
# explore: orders { … }
#
# explore: order_facts { … }
#
# explore: customer_facts {
#   persist_with: customers_datagroup
#   …
# }
#
# explore: customer_background {
#   persist_with: customers_datagroup
#   …
# }

explore: order_items {
  label: "Order Items"

  join: inventory_items {
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

  join: products {
    sql: ${distribution_centers.id} = ${products.distribution_center_id} ;;
    type: left_outer
    relationship: one_to_many
  }
}

explore: events {
  label: "User Events"
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
