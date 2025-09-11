<template>
  <view class="container">
    <!-- Profile Header -->
    <view class="profile-header">
      <view class="profile-top">
        <view class="profile-avatar">
          <image src="https://gitee.com/christiangann/tatabase-image/raw/main/avatar/0003.png" mode="aspectFill"></image>
        </view>
        <view class="profile-info">
          <view class="profile-phone">185****9654</view>
          <view class="profile-growth">
            <text>成长值</text>
            <text class="growth-value">85/120</text>
          </view>
          <view class="progress-bar">
            <view class="progress-fill" style="width: 70%;"></view>
          </view>
        </view>
        <view class="edit-profile">
          <text>编辑资料</text>
          <text class="gx-i gx-i-forward gx-fs-16"></text>
        </view>
      </view>
      
      <view class="financial-summary">
        <view class="financial-item">
          <view class="icon-container">
            <text class="gx-i gx-i-yen gx-fs-16 gx-color-error"></text>
          </view>
          <view class="financial-details">
            <view class="financial-amount">128.36</view>
            <view class="financial-label">累计收益(元)</view>
          </view>
        </view>
        <view class="financial-item">
          <view class="icon-container blue">
            <text class="gx-i gx-i-yen gx-fs-16 gx-color-info"></text>
          </view>
          <view class="financial-details">
            <view class="financial-amount">105.06</view>
            <view class="financial-label">账户余额(元)</view>
          </view>
        </view>
      </view>
    </view>
    
    <view class="orders-section">
      <view class="section-header">
        <text>我的订单</text>
        <view class="view-all">
          <text>全部订单</text>
          <text class="gx-i gx-i-forward gx-fs-16"></text>
        </view>
      </view>
      
      <view class="order-categories">
        <view class="category-item">
          <view class="category-icon">
            <text class="gx-fs-32 gx-i gx-i-wallet"></text>
          </view>
          <text>待付款</text>
        </view>
        <view class="category-item">
          <view class="category-icon">
            <text class="gx-fs-32 gx-i gx-i-package"></text>
          </view>
          <text>待发货</text>
        </view>
        <view class="category-item">
          <view class="category-icon">
            <text class="gx-fs-32 gx-i gx-i-shipping"></text>
            <text class="badge">4</text>
          </view>
          <text>待收货</text>
        </view>
        <view class="category-item">
          <view class="category-icon">
            <text class="gx-fs-32 gx-i gx-i-review"></text>
          </view>
          <text>待评价</text>
        </view>
        <view class="category-item">
          <view class="category-icon">
            <text class="gx-fs-32 gx-i gx-i-support">️</text>
          </view>
          <text>售后</text>
        </view>
      </view>
    </view>
    
    <view class="signin-banner gx-px-16">
      <view class="banner-content">
        <view class="banner-text">
          <text class="banner-title">签到「领好礼」</text>
          <text class="banner-subtitle">连续签到7天可领取神秘大礼包</text>
        </view>
        <button class="claim-button">立即领取</button>
      </view>
    </view>
    
    <!-- Common Tools -->
    <view class="tools-section">
      <view class="section-title">常用工具</view>
      <view class="tools-grid">
        <view class="tool-item">
          <view class="tool-icon">
            <text class="gx-i gx-i-bookmarks gx-fs-28"></text>
          </view>
          <text class="tool-name">我的收藏</text>
        </view>
        <view class="tool-item">
          <view class="tool-icon">
            <text class="gx-i gx-i-order gx-fs-28"></text>
          </view>
          <text class="tool-name">我的订单</text>
        </view>
        <view class="tool-item" @tap="route.gotoProfileSettings">
          <view class="tool-icon">
            <text class="gx-i gx-i-settings gx-fs-28"></text>
          </view>
          <text class="tool-name">设置</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
const app = getApp();
import { sdk } from '@/sdk/sdk';
import * as route from '@/route';
import '@/app.css';

export default {
  data() {
    return {
      route: route,
    };
  },
  methods: {
    
  }
};
</script>

<style lang="scss">
.container {
  padding-bottom: 100rpx;
  background-color: #f8f8f8;
  min-height: 100vh;
  position: relative;
}

.profile-header {
  background-color: #fff;
  padding: 30rpx;
  border-radius: 0 0 20rpx 20rpx;
}

.profile-top {
  display: flex;
  align-items: center;
  margin-bottom: 40rpx;
}

.profile-avatar {
  width: 120rpx;
  height: 120rpx;
  border-radius: 50%;
  overflow: hidden;
  margin-right: 20rpx;
  
  image {
    width: 100%;
    height: 100%;
  }
}

.profile-info {
  flex: 1;
}

.profile-phone {
  font-size: 36rpx;
  font-weight: bold;
  margin-bottom: 10rpx;
}

.profile-growth {
  display: flex;
  align-items: center;
  font-size: 26rpx;
  color: #888;
  margin-bottom: 10rpx;
  
  .growth-value {
    margin-left: 10rpx;
    color: #333;
  }
}

.progress-bar {
  height: 10rpx;
  background-color: #f0f0f0;
  border-radius: 10rpx;
  overflow: hidden;
  width: 100%;
  
  .progress-fill {
    height: 100%;
    background: linear-gradient(to right, #ff6b6b, #ff4757);
  }
}

.edit-profile {
  color: #999;
  font-size: 24rpx;
  display: flex;
  align-items: center;
  
  .icon-right {
    margin-left: 4rpx;
  }
}

.financial-summary {
  display: flex;
  justify-content: space-between;
  margin-top: 20rpx;
}

.financial-item {
  flex: 1;
  background-color: #fff;
  padding: 20rpx;
  border-radius: 16rpx;
  display: flex;
  align-items: center;
  
  &:first-child {
    margin-right: 20rpx;
  }
}

.icon-container {
  width: 60rpx;
  height: 60rpx;
  border-radius: 50%;
  background-color: #ffe8e8;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 20rpx;
  
  &.blue {
    background-color: #e8f4ff;
  }
  
  .icon {
    color: #ff6b6b;
    font-size: 32rpx;
  }
  
  &.blue .icon {
    color: #4b7bec;
  }
}

.financial-details {
  flex: 1;
}

.financial-amount {
  font-size: 32rpx;
  font-weight: bold;
}

.financial-label {
  font-size: 22rpx;
  color: #888;
}

.orders-section {
  margin-top: 20rpx;
  background-color: #fff;
  border-radius: 16rpx;
  padding: 30rpx;
}

.section-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 30rpx;
  
  .view-all {
    color: #999;
    font-size: 24rpx;
    display: flex;
    align-items: center;
  }
}

.order-categories {
  display: flex;
  justify-content: space-between;
}

.category-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  font-size: 24rpx;
}

.category-icon {
  width: 80rpx;
  height: 80rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  margin-bottom: 10rpx;
  
  .icon {
    font-size: 40rpx;
  }
  
  .badge {
    position: absolute;
    top: -10rpx;
    right: -10rpx;
    background-color: #ff4757;
    color: #fff;
    font-size: 20rpx;
    width: 32rpx;
    height: 32rpx;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
  }
}

.signin-banner {
  margin: 20rpx 0;
  border-radius: 16rpx;
  overflow: hidden;
  
  .banner-content {
    padding: 30rpx;
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: linear-gradient(to right, #ffb88c, #ff6b6b);
    color: #fff;
  }
  
  .banner-title {
    font-size: 32rpx;
    font-weight: bold;
    margin-bottom: 10rpx;
    display: block;
  }
  
  .banner-subtitle {
    font-size: 24rpx;
    opacity: 0.8;
  }
  
  .claim-button {
    background-color: #fff;
    color: #ff6b6b;
    padding: 10rpx 30rpx;
    border-radius: 30rpx;
    font-size: 26rpx;
    border: none;
    min-width: 160rpx;
    text-align: center;
  }
}

.tools-section {
  background-color: #fff;
  border-radius: 16rpx;
  padding: 30rpx;
}

.section-title {
  font-size: 30rpx;
  font-weight: bold;
  margin-bottom: 30rpx;
}

.tools-grid {
  display: flex;
  flex-wrap: wrap;
}

.tool-item {
  width: 25%;
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 30rpx;
}

.tool-icon {
  width: 80rpx;
  height: 80rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 10rpx;
  
  .icon {
    font-size: 40rpx;
  }
}

.tool-name {
  font-size: 24rpx;
  color: #333;
}

.tab-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  height: 100rpx;
  background-color: #fff;
  display: flex;
  box-shadow: 0 -2rpx 10rpx rgba(0,0,0,0.05);
}

.tab-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  font-size: 22rpx;
  color: #999;
  
  &.active {
    color: #ff6b6b;
  }
  
  .tab-icon {
    font-size: 40rpx;
    margin-bottom: 6rpx;
  }
}

.floating-cart {
  position: fixed;
  right: 30rpx;
  bottom: 120rpx;
  width: 90rpx;
  height: 90rpx;
  background-color: #ff6b6b;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-size: 40rpx;
  box-shadow: 0 4rpx 20rpx rgba(255, 107, 107, 0.4);
}
</style>