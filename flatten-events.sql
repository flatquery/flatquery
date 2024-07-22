-- Brought to you by the team at FlatQuery
-- For full documentation and details of the free, community platform which deploys these queries automatically, visit https://flatquery.com

-- Flatten Events

select T1.*,

 /* --- Calculated Fields (Optional Enrichment)--- */
  
   -- Page Path
    case when page_location like '%/?%'
    then REPLACE(LEFT(RIGHT(page_location,(LENGTH(page_location)-INSTR(page_location, '/',1,3)+1)),INSTR(RIGHT(page_location,      
        (LENGTH(page_location)-INSTR(page_location, '/',1,3)+1)), '?')),'?','')
    else RIGHT(page_location,(LENGTH(page_location)-INSTR(page_location, '/',1,3)+1)) end AS page_path,
   -- Page Path + Query
    RIGHT(page_location,(LENGTH(page_location)-INSTR(page_location, '/',1,3)+1)) AS page_path_query,
    
   -- First User Source / Medium
     CONCAT( first_user_source, ' / ', first_user_medium ) AS first_user_source_medium,

   -- First User Channel
    case 
    when first_user_source = '(direct)' and (first_user_medium in ('(not set)','(none)')) then 'Direct'
    when regexp_contains(first_user_campaign, 'cross-network') then 'Cross-network'
    when (regexp_contains(first_user_source,'alibaba|amazon|google shopping|shopify|etsy|ebay|stripe|walmart')
        or regexp_contains(first_user_campaign, '^(.*(([^a-df-z]|^)shop|shopping).*)$'))
        and regexp_contains(first_user_medium, '^(.*cp.*|ppc|paid.*)$') then 'Paid Shopping'
    when regexp_contains(first_user_source,'baidu|bing|duckduckgo|ecosia|google|yahoo|yandex')
        and regexp_contains(first_user_medium,'^(.*cp.*|ppc|paid.*)$') then 'Paid Search'
    when regexp_contains(first_user_source,'badoo|meta|facebook|fb|instagram|linkedin|pinterest|tiktok|twitter|whatsapp')
        and regexp_contains(first_user_medium,'^(.*cp.*|ppc|paid.*)$') then 'Paid Social'
    when regexp_contains(first_user_source,'dailymotion|disneyplus|netflix|youtube|vimeo|twitch|vimeo|youtube')
        and regexp_contains(first_user_medium,'^(.*cp.*|ppc|paid.*)$') then 'Paid Video'
    when first_user_medium in ('display', 'banner', 'expandable', 'interstitial', 'cpm') then 'Display'
    when regexp_contains(first_user_source,'alibaba|amazon|google shopping|shopify|etsy|ebay|stripe|walmart')
        or regexp_contains(first_user_campaign, '^(.*(([^a-df-z]|^)shop|shopping).*)$') then 'Organic Shopping'
    when regexp_contains(first_user_source,'badoo|meta|facebook|fb|instagram|linkedin|pinterest|tiktok|twitter|whatsapp')
        or first_user_medium in ('social','social-network','social-media','sm','social network','social media') then 'Organic Social'
    when regexp_contains(first_user_source,'dailymotion|disneyplus|netflix|youtube|vimeo|twitch|vimeo|youtube')
        or regexp_contains(first_user_medium,'^(.*video.*)$') then 'Organic Video'
    when regexp_contains(first_user_source,'baidu|bing|duckduckgo|ecosia|google|yahoo|yandex')
        or first_user_medium = 'organic' then 'Organic Search'
    when regexp_contains(first_user_source,'email|e-mail|e_mail|e mail')
        or regexp_contains(first_user_medium,'email|e-mail|e_mail|e mail') then 'Email'
    when first_user_medium = 'affiliate' then 'Affiliates'
    when first_user_medium = 'referral' then 'Referral'
    when first_user_medium = 'audio' then 'Audio'
    when first_user_medium = 'sms' then 'SMS'
    when first_user_medium like '%push'
        or regexp_contains(first_user_medium,'mobile|notification') then 'Mobile Push Notifications'
    else 'Unassigned' end as first_user_channel,  

   -- Session Source / Medium
     CONCAT( session_source, ' / ', session_medium) AS session_source_medium,

   -- Session Channel
    case 
    when session_source = '(direct)' and (session_medium in ('(not set)','(none)')) then 'Direct'
    when regexp_contains(session_campaign, 'cross-network') then 'Cross-network'
    when (regexp_contains(session_source,'alibaba|amazon|google shopping|shopify|etsy|ebay|stripe|walmart')
        or regexp_contains(session_campaign, '^(.*(([^a-df-z]|^)shop|shopping).*)$'))
        and regexp_contains(session_medium, '^(.*cp.*|ppc|paid.*)$') then 'Paid Shopping'
    when regexp_contains(session_source,'baidu|bing|duckduckgo|ecosia|google|yahoo|yandex')
        and regexp_contains(session_medium,'^(.*cp.*|ppc|paid.*)$') then 'Paid Search'
    when regexp_contains(session_source,'badoo|meta|facebook|fb|instagram|linkedin|pinterest|tiktok|twitter|whatsapp')
        and regexp_contains(session_medium,'^(.*cp.*|ppc|paid.*)$') then 'Paid Social'
    when regexp_contains(session_source,'dailymotion|disneyplus|netflix|youtube|vimeo|twitch|vimeo|youtube')
        and regexp_contains(session_medium,'^(.*cp.*|ppc|paid.*)$') then 'Paid Video'
    when session_medium in ('display', 'banner', 'expandable', 'interstitial', 'cpm') then 'Display'
    when regexp_contains(session_source,'alibaba|amazon|google shopping|shopify|etsy|ebay|stripe|walmart')
        or regexp_contains(session_campaign, '^(.*(([^a-df-z]|^)shop|shopping).*)$') then 'Organic Shopping'
    when regexp_contains(session_source,'badoo|facebook|fb|instagram|linkedin|pinterest|tiktok|twitter|whatsapp')
        or session_medium in ('social','social-network','social-media','sm','social network','social media') then 'Organic Social'
    when regexp_contains(session_source,'dailymotion|disneyplus|netflix|youtube|vimeo|twitch|vimeo|youtube')
        or regexp_contains(session_medium,'^(.*video.*)$') then 'Organic Video'
    when regexp_contains(session_source,'baidu|bing|duckduckgo|ecosia|google|yahoo|yandex')
        or session_medium = 'organic' then 'Organic Search'
    when regexp_contains(session_source,'email|e-mail|e_mail|e mail')
        or regexp_contains(session_medium,'email|e-mail|e_mail|e mail') then 'Email'
    when session_medium = 'affiliate' then 'Affiliates'
    when session_medium = 'referral' then 'Referral'
    when session_medium = 'audio' then 'Audio'
    when session_medium = 'sms' then 'SMS'
    when session_medium like '%push'
        or regexp_contains(session_medium,'mobile|notification') then 'Mobile Push Notifications'
    else 'Unassigned' end as session_channel,

 /* --- End of Calculated Fields (Optional Enrichment)--- */ 

FROM

(
select
    /* -- Include Existing Fields -- */ 
    
    -- General Event Info
    CONCAT(CAST(event_timestamp AS STRING),user_pseudo_id, (CAST(100*RAND() AS INT64)) ) AS event_id,
    parse_date('%Y%m%d',event_date) AS event_date,
    event_name,
    event_timestamp,
    event_previous_timestamp,
    event_bundle_sequence_id,
    event_server_timestamp_offset,
    stream_id,
    platform,

    -- User Info 
    user_id,
    user_pseudo_id,
    user_first_touch_timestamp,
    user_ltv.revenue AS user_ltv_revenue,
    user_ltv.currency AS user_ltv_currency,
    
    -- Privacy Info 
    privacy_info.analytics_storage AS privacy_info_analytics_storage,
    privacy_info.ads_storage AS privacy_info_ads_storage,
    privacy_info.uses_transient_token AS privacy_info_uses_transient_token,
    
   -- App Info 
    app_info.id AS app_id, 
    app_info.version AS app_version,
    app_info.install_store AS app_install_store,
    app_info.firebase_app_id AS app_firebase_app_id,
    app_info.install_source AS app_install_source,
    
    -- Mobile Device
    device.mobile_brand_name AS mobile_brand_name,
    device.mobile_model_name AS mobile_model_name,
    device.mobile_marketing_name AS mobile_marketing_name,
    device.mobile_os_hardware_model AS mobile_os_hardware_model,
    
    -- General Device 
    device.category AS device_category,
    device.operating_system AS device_os,
    device.operating_system_version AS device_os_version,
    device.vendor_id AS device_vendor_id,
    device.advertising_id AS device_advertising_id,
    device.language AS device_language,
    device.is_limited_ad_tracking AS device_limited_ad_tracking,
    device.time_zone_offset_seconds AS device_time_zone_offset_seconds,
    device.browser AS device_browser,
    device.browser_version AS device_browser_version,
    
    -- Device Web Info 
    device.web_info.browser AS device_web_browser,
    device.web_info.hostname AS hostname,
    
    -- Geo 
    geo.continent AS geo_continent,
    geo.country AS geo_country,
    geo.region AS geo_region,
    geo.city AS geo_city,
    geo.sub_continent AS geo_subcontinent,
    geo.metro AS geo_metro,
   
    -- User Source 
    traffic_source.source AS first_user_source,
    traffic_source.medium AS first_user_medium,
    traffic_source.name AS first_user_campaign,

    -- Manual Source - Typically UTM & autotagged values - will often match 'session_source' fields
    collected_traffic_source.manual_campaign_id AS manual_campaign_id,
    collected_traffic_source.manual_campaign_name AS manual_campaign_name,
    collected_traffic_source.manual_source AS manual_source,
    collected_traffic_source.manual_medium AS manual_medium,
    collected_traffic_source.manual_term AS manual_term,
    collected_traffic_source.manual_content AS manual_content,
    collected_traffic_source.gclid AS gclid,
    collected_traffic_source.dclid AS dclid,
    collected_traffic_source.srsltid AS srsltid,


    /* --- Ecommerce (Optional) Keep or Remove entire section --- */
    
    -- Item Properties
      items [SAFE_OFFSET(0)].item_id AS item_id,
      items [SAFE_OFFSET(0)].item_name AS item_name,
      items [SAFE_OFFSET(0)].item_brand AS item_brand,
      items [SAFE_OFFSET(0)].item_variant AS item_variant,
      items [SAFE_OFFSET(0)].item_category AS item_category,
      items [SAFE_OFFSET(0)].item_category2 AS item_category2,
      items [SAFE_OFFSET(0)].item_category3 AS item_category3,
      items [SAFE_OFFSET(0)].item_category4 AS item_category4,
      items [SAFE_OFFSET(0)].item_category5 AS item_category5,
      items [SAFE_OFFSET(0)].price_in_usd AS item_price_in_usd,
      items [SAFE_OFFSET(0)].price AS item_price,
      items [SAFE_OFFSET(0)].quantity AS item_quantity,
      items [SAFE_OFFSET(0)].item_revenue_in_usd AS item_revenue_in_usd,
      items [SAFE_OFFSET(0)].item_revenue AS item_revenue,
      items [SAFE_OFFSET(0)].item_refund_in_usd AS item_refund_in_usd,
      items [SAFE_OFFSET(0)].item_refund AS item_refund,
      items [SAFE_OFFSET(0)].coupon AS item_coupon,
      items [SAFE_OFFSET(0)].affiliation AS item_affiliation,
      items [SAFE_OFFSET(0)].location_id AS location_id,
      items [SAFE_OFFSET(0)].item_list_id AS item_list_id,
      items [SAFE_OFFSET(0)].item_list_name AS item_list_name,
      items [SAFE_OFFSET(0)].item_list_index AS item_list_index,
      items [SAFE_OFFSET(0)].promotion_id AS item_promotion_id,
      items [SAFE_OFFSET(0)].promotion_name AS item_promotion_name,
      items [SAFE_OFFSET(0)].creative_name AS item_creative_name,
      items [SAFE_OFFSET(0)].creative_slot AS item_creative_slot,
      
      -- General Ecommerce
      ecommerce.total_item_quantity AS ecommerce_total_item_quantity,
      ecommerce.purchase_revenue_in_usd AS ecommerce_purchase_revenue_in_usd,
      ecommerce.purchase_revenue AS ecommerce_purchase_revenue,
      ecommerce.refund_value_in_usd AS ecommerce_refund_value_in_usd,
      ecommerce.refund_value AS ecommerce_refund_value,
      ecommerce.shipping_value_in_usd AS ecommerce_shipping_value_in_usd,
      ecommerce.shipping_value AS ecommerce_shipping_value,
      ecommerce.tax_value_in_usd AS ecommerce_tax_value_in_usd,
      ecommerce.tax_value AS ecommerce_tax_value,
      ecommerce.unique_items AS ecommerce_unique_items,
      ecommerce.transaction_id AS ecommerce_transaction_id,
    
    /* --- End of Ecommerce Section ---*/
    

    /* -- Standard Event Params --*/

    --Integer values
    (select value.int_value from unnest(event_params) where key = 'ga_session_id') as ga_session_id,
    (select value.int_value from unnest(event_params) where key = 'ga_session_id') as ga_session_number,
    (select value.int_value from unnest(event_params) where key = 'entrances') as entrances,
    (select value.int_value from unnest(event_params) where key = 'batch_page_id') as batch_page_id,
    (select value.int_value from unnest(event_params) where key = 'batch_ordering_id') as batch_ordering_id,
    
    -- String values

        -- Page attributes
    (select value.string_value from unnest(event_params) where key = 'page_location') as page_location,
    (select value.string_value from unnest(event_params) where key = 'page_title') as page_title,
    (select value.string_value from unnest(event_params) where key = 'page_referrer') as page_referrer,

        -- Session source attributes
    (select value.string_value from unnest(event_params) where key = 'source') as session_source,
    (select value.string_value from unnest(event_params) where key = 'medium') as session_medium,
    (select value.string_value from unnest(event_params) where key = 'campaign') as session_campaign,

         -- Consent 
    (select value.string_value from unnest(event_params) where key = 'ad_personalization') as ad_personalization,
    (select value.string_value from unnest(event_params) where key = 'analytics_storage') as analytics_storage,
    (select value.string_value from unnest(event_params) where key = 'ads_storage') as ads_storage,
    (select value.string_value from unnest(event_params) where key = 'ad_user_data') as ad_user_data,

    /* -- Custom Parameters & Properties - add your own here -- */

    /* -- Custom Event Parameters -- */
    (select value.string_value from unnest(event_params) where key = '<insert key>') as event_string_value,
    (select value.int_value from unnest(event_params) where key = '<insert key>') as event_integer_value,

    /* -- Custom User Properties -- */
    (select value.string_value from unnest(user_properties) where key = '<insert key>') as user_string_value,
    (select value.int_value from unnest(user_properties) where key = '<insert key>') as user_integer_value,

     /* -- Custom Item Properties -- */
    (select value.string_value from unnest(items[SAFE_OFFSET(0)].item_params) where key = '<insert key>') as item_string_value,
    (select value.int_value from unnest(items[SAFE_OFFSET(0)].item_params) where key = '<insert key>') as item_integer_value,

from
    -- Google Analytics 4 export location in bigquery
    `<projectame>.<datasetName>.events_*` -- Example: 'flatquery.analytics_388448675.events_*'

     ) t1

-- End of query with ALL events

-- Or specify which events you want to 'Flatten'.

    WHERE t1.event_name in
   ('session_start',
    'page_view',
    'purchase'
   )
   
