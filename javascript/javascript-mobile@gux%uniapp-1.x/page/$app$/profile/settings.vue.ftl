<template>
  <view class="settings-container">    
    <view class="settings-list">
      <view class="setting-item" @tap="route.gotoProfileEdit()">
        <text class="setting-label">基本信息</text>
        <view class="setting-value">
          <text class="gx-i gx-i-forward"></text>
        </view>
      </view>
      <view class="setting-item">
        <text class="setting-label">Notifications</text>
        <switch :checked="notificationsEnabled" @change="" color="#3a5b94" />
      </view>
      <view class="setting-item">
        <text class="setting-label">Language</text>
        <view class="setting-value">
          <text>EN</text>
          <text class="gx-i gx-i-forward"></text>
        </view>
      </view>
      <view class="setting-item">
        <text class="setting-label">Temperature</text>
        <view class="setting-value">
          <text>°C</text>
          <text class="gx-i gx-forward"></text>
        </view>
      </view>
      <view class="setting-item">
        <text class="setting-label">Dark mood</text>
        <switch :checked="darkModeEnabled" @change="" color="#3a5b94" />
      </view>
      <view class="setting-item">
        <text class="setting-label">隐私政策</text>
        <text class="gx-i gx-i-forward"></text>
      </view>
      <view class="setting-item">
        <text class="setting-label">帮助</text>
        <text class="gx-i gx-i-forward"></text>
      </view>
      <view class="setting-item" @tap="doLogout">
        <text class="setting-label gx-color-error">退出登录</text>
        <text class="gx-i gx-i-forward"></text>
      </view>
    </view>
    <view class="version">
      <text>版本 1.0.0</text>
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
      notificationsEnabled: true,
      darkModeEnabled: true,
      userProfile: {
        name: 'Ziad Hamdy m',
        email: 'zizo.hamdy016@gmail.com',
        location: 'alex, egypt'
      }
    }
  },
  methods: {
    doLogout() {
      uni.showModal({
        title: '退出登录',
        content: '确定您要退出登录？',
        success: (res) => {
          if (res.confirm) {
            uni.removeStorageSync('token');
            uni.removeStorageSync('userInfo');
            uni.reLaunch({
              url: '/pages/login/login'
            });
          }
        }
      });
    },
  }
}
</script>

<style>
.settings-container {
  padding: 0 0 30rpx 0;
  background-color: #f9f9f9;
  height: 100vh;
}

.header {
  display: flex;
  align-items: center;
  padding: 20rpx 30rpx;
  background-color: #fff;
}

.back-btn {
  padding: 10rpx;
}

.title {
  flex: 1;
  text-align: center;
  font-size: 36rpx;
  font-weight: 500;
  color: #3a5b94;
  margin-right: 40rpx;
}

.profile-section {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 30rpx;
  background-color: #fff;
  margin-bottom: 20rpx;
}

.profile-content {
  display: flex;
  align-items: center;
}

.avatar {
  width: 100rpx;
  height: 100rpx;
  border-radius: 50%;
  margin-right: 20rpx;
}

.profile-info {
  display: flex;
  flex-direction: column;
}

.profile-name {
  font-size: 32rpx;
  font-weight: 500;
  color: #333;
}

.profile-email {
  font-size: 26rpx;
  color: #666;
  margin-top: 5rpx;
}

.settings-list {
  background-color: #fff;
}

.setting-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 30rpx;
  border-bottom: 1rpx solid #f0f0f0;
}

.setting-label {
  font-size: 32rpx;
  color: #333;
}

.setting-value {
  display: flex;
  align-items: center;
  color: #666;
}

.setting-value text:first-child {
  margin-right: 10rpx;
}

.logout {
  margin-top: 20rpx;
}

.version {
  text-align: center;
  font-size: 24rpx;
  color: #999;
  margin-top: 40rpx;
}
</style>