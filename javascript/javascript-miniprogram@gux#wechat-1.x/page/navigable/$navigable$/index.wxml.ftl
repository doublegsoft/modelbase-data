<gx-navigation-bar id="navigationBar" title="我的"  backable="{{false}}" />
<view class="page navigable" style="top:{{top}}px;">
  <view class="gx-w-full gx-d-flex" style="height: 156px;">
    <image class="gx-wh-128 gx-m-auto gx-b-round" mode="aspectFit" src="{{user.avatar}}"></image>
  </view>
  <view class="gx-mx-8">
    <navigator bindtap="gotoMine" url="#" class="gx-tile gx-pl-20 gx-py-12 gx-fs-16" role="navigator">
      <text class="gx-tile-body">我的资料</text>
      <view class="fas fa-angle-right gx-fs-18 access"></view>
    </navigator>
    <navigator bindtap="gotoFamilyMemberList" url="#" class="gx-tile gx-pl-20 gx-py-12 gx-fs-16" role="navigator">
      <text class="gx-tile-body">家庭成员</text>
      <view class="fas fa-angle-right gx-fs-18 access"></view>
    </navigator>
    <navigator bindtap="gotoAddressList" url="#" class="gx-tile gx-pl-20 gx-py-12 gx-fs-16" role="navigator">
      <text class="gx-tile-body">地址管理</text>
      <view class="fas fa-angle-right gx-fs-18 access"></view>
    </navigator>
    <navigator bindtap="gotoTodo" url="#" class="gx-tile gx-pl-20 gx-py-12 gx-fs-16" role="navigator">
      <text class="gx-tile-body">退出登录</text>
      <view class="fas fa-angle-right gx-fs-18 access"></view>
    </navigator>
  </view>
</view>
