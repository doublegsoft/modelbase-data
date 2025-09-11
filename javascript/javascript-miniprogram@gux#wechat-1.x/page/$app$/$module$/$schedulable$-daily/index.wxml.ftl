<view class="page">
  <gx-calendar id="event" isOpen="{{true}}" selected="{{selectedDays}}" lockDay="{{lockday}}" bind:select="cmfclick" bind:getdate="getdate" bind:checkall="checkall" bind:clear="clear"></gx-calendar>
  <view class="meeting-card">
    <view class="platform">
      <text>Zoom</text>
      <view class="avatars">
        <image wx:for="{{participants}}" wx:key="index" src="{{item.avatar}}" mode="aspectFill"></image>
      </view>
    </view>
    <view class="title">Presentation New Project</view>
    <view class="gx-row">
      <view class="duration gx-mr-16">
        <text class="number">30</text>
        <text class="unit">分钟</text>
      </view>
      <view class="time-info gx-ml-auto">
        <view class="time-item">
          <text class="label">Start</text>
          <text class="value">9:30 AM</text>
        </view>
        <view class="time-item">
          <text class="label">End</text>
          <text class="value">10:00 AM</text>
        </view>
      </view>
    </view>
  </view>
  <view class="meeting-card">
    <view class="platform">
      <text>Zoom</text>
      <view class="avatars">
        <image wx:for="{{participants}}" wx:key="index" src="{{item.avatar}}" mode="aspectFill"></image>
      </view>
    </view>
    <view class="title">Presentation New Project</view>
    <view class="gx-row">
      <view class="duration gx-mr-16">
        <text class="number">30</text>
        <text class="unit">分钟</text>
      </view>
      <view class="time-info gx-ml-auto">
        <view class="time-item">
          <text class="label">Start</text>
          <text class="value">9:30 AM</text>
        </view>
        <view class="time-item">
          <text class="label">End</text>
          <text class="value">10:00 AM</text>
        </view>
      </view>
    </view>
  </view>
</view>
