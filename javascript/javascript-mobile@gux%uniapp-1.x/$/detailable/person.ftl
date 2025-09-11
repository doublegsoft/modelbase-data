<template>
  <view class="container">
    <!-- Header with back button and action icons -->
    <view class="header">
      <view class="back-btn" @click="goBack">
        <text class="icon">←</text>
      </view>
      <view class="action-icons">
        <view class="icon-btn favorite">
          <text class="icon">♡</text>
        </view>
        <view class="icon-btn message">
          <text class="icon">💬</text>
        </view>
      </view>
    </view>
    
    <!-- User profile section -->
    <view class="profile-section">
      <view class="avatar-container">
        <view class="avatar">
          <text class="avatar-placeholder">👤</text>
        </view>
      </view>
      <view class="profile-divider"></view>
    </view>
    
    <!-- Tabs section -->
    <view class="tabs-container">
      <view class="tabs">
        <view class="tab" :class="{'active': activeTab === 'tab1'}" @click="setActiveTab('tab1')">
          <text class="tab-text">Tab 1</text>
        </view>
        <view class="tab" :class="{'active': activeTab === 'tab2'}" @click="setActiveTab('tab2')">
          <text class="tab-text">Tab 2</text>
        </view>
        <view class="tab" :class="{'active': activeTab === 'tab3'}" @click="setActiveTab('tab3')">
          <text class="tab-text">Tab 3</text>
        </view>
      </view>
    </view>
    
    <!-- Content sections -->
    <view class="content-section">
      <view class="section-header">
        <text class="section-title">Section 1</text>
      </view>
      <view class="section-progress">
        <view class="progress-bar">
          <view class="progress" :style="{width: '40%'}"></view>
        </view>
      </view>
      <view class="item-row">
        <view class="item" v-for="(item, index) in [1, 2, 3, 4]" :key="index">
          <view class="item-content"></view>
        </view>
      </view>
    </view>
    
    <view class="content-section">
      <view class="section-header">
        <text class="section-title">Section 2</text>
      </view>
      <view class="section-progress">
        <view class="progress-bar">
          <view class="progress" :style="{width: '65%'}"></view>
        </view>
      </view>
      <view class="item-row">
        <view class="item" v-for="(item, index) in [1, 2, 3, 4]" :key="index">
          <view class="item-content"></view>
        </view>
      </view>
    </view>
    
    <!-- Bottom navigation -->
    <view class="bottom-nav">
      <view class="nav-item">
        <view class="nav-icon">🏠</view>
      </view>
      <view class="nav-item">
        <view class="nav-icon">📅</view>
      </view>
      <view class="nav-item">
        <view class="nav-icon">💬</view>
      </view>
      <view class="nav-item active">
        <view class="nav-icon">👤</view>
        <view class="nav-indicator"></view>
      </view>
    </view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      activeTab: 'tab1'
    }
  },
  methods: {
    goBack() {
      uni.navigateBack({
        delta: 1
      });
    },
    setActiveTab(tab) {
      this.activeTab = tab;
    }
  }
}
</script>

<style>
.container {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background-color: #e9e9e9;
  position: relative;
}

/* Header styles */
.header {
  display: flex;
  justify-content: space-between;
  padding: 30rpx;
  align-items: center;
}

.back-btn {
  width: 60rpx;
  height: 60rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.action-icons {
  display: flex;
  gap: 20rpx;
}

.icon-btn {
  width: 80rpx;
  height: 80rpx;
  border-radius: 40rpx;
  background-color: #000;
  display: flex;
  align-items: center;
  justify-content: center;
}

.icon {
  font-size: 36rpx;
  color: #fff;
}

/* Profile section */
.profile-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20rpx 0 40rpx 0;
}

.avatar-container {
  margin-bottom: 30rpx;
}

.avatar {
  width: 180rpx;
  height: 180rpx;
  border-radius: 90rpx;
  background-color: #000;
  display: flex;
  align-items: center;
  justify-content: center;
}

.avatar-placeholder {
  color: #fff;
  font-size: 80rpx;
}

.profile-divider {
  width: 80%;
  height: 6rpx;
  background-color: #000;
}

/* Tabs section */
.tabs-container {
  background-color: #fff;
  border-radius: 40rpx 40rpx 0 0;
  padding: 30rpx;
  margin-top: 20rpx;
}

.tabs {
  display: flex;
  border: 4rpx solid #000;
  border-radius: 100rpx;
  overflow: hidden;
}

.tab {
  flex: 1;
  padding: 20rpx 0;
  text-align: center;
}

.tab.active {
  background-color: #000;
}

.tab-text {
  font-size: 28rpx;
  color: #000;
}

.tab.active .tab-text {
  color: #fff;
}

/* Content sections */
.content-section {
  padding: 30rpx;
  background-color: #fff;
}

.section-header {
  margin-bottom: 20rpx;
}

.section-title {
  font-size: 32rpx;
  font-weight: bold;
}

.section-progress {
  margin-bottom: 30rpx;
}

.progress-bar {
  height: 10rpx;
  background-color: #e0e0e0;
  border-radius: 10rpx;
}

.progress {
  height: 100%;
  background-color: #000;
  border-radius: 10rpx;
}

.item-row {
  display: flex;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 20rpx;
  margin-bottom: 30rpx;
}

.item {
  flex: 1;
  min-width: 150rpx;
}

.item-content {
  height: 80rpx;
  background-color: #e0e0e0;
  border-radius: 40rpx;
}

/* Bottom navigation */
.bottom-nav {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  display: flex;
  justify-content: space-around;
  background-color: #fff;
  padding: 20rpx 0;
  border-top: 2rpx solid #eee;
}

.nav-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 10rpx 0;
  position: relative;
}

.nav-icon {
  font-size: 48rpx;
  margin-bottom: 10rpx;
}

.nav-indicator {
  position: absolute;
  bottom: 0;
  width: 60rpx;
  height: 6rpx;
  background-color: #000;
  border-radius: 3rpx;
}

/* Media queries for different screen sizes */
@media screen and (min-width: 768px) {
  .item-row {
    gap: 30rpx;
  }
  
  .avatar {
    width: 240rpx;
    height: 240rpx;
    border-radius: 120rpx;
  }
}
</style>