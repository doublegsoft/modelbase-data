
<#macro print_html_of_list_view obj indent>
<scroll-view scroll-y="{{true}}" onScrollToLower="scrollMytrip" class="schedule-scroll">
  <view a:for="{{list}}" class="schedule-detail">
    <view class="schedule-place">{{item.title}}</view>
    <view class="schedule-trainNumber padd font">{{item.remarksa}}</view>
    <view class="schedule-time padd font">{{item.remarksb}}</view>
  </view>
  <view class="spinner" style="{{show ? '' : 'display:none'}}">
    <view class="bounce1 bounce"></view>
    <view class="bounce2 bounce"></view>
    <view class="bounce3 bounce"></view>
    <view style="margin:20rpx 0 0 20rpx;color:#666666;">加载中...</view>
  </view>
</scroll-view>
</#macro>