<template>
  <view class="filter-container">
    <view class="header">
      <input placeholder="搜索关键字"></input>
    </view>
    <!-- Sort options -->
    <view class="section">
      <view class="section-title">Sort by:</view>
      <view class="option-pills">
        <view class="pill active">
          <text>Featured</text>
        </view>
        <view class="pill">
          <text>Distance</text>
        </view>
        <view class="pill">
          <text>Newest</text>
        </view>
        <view class="pill">
          <text>Ratings</text>
        </view>
      </view>
    </view>
    
    <!-- Distance options -->
    <view class="section">
      <view class="section-title">Distance (Km)</view>
      <view class="option-pills">
        <view class="pill active">
          <text>Auto</text>
        </view>
        <view class="pill">
          <text>1</text>
        </view>
        <view class="pill">
          <text>4</text>
        </view>
        <view class="pill">
          <text>16</text>
        </view>
        <view class="pill">
          <text>40</text>
        </view>
        <view class="pill">
          <text>80</text>
        </view>
        <view class="pill">
          <text>90</text>
        </view>
      </view>
    </view>
    
    <!-- Filters section -->
    <view class="section">
      <view class="section-title">Filters</view>
    </view>
    
    <!-- Dropdown options -->
    <view class="dropdown-section">
      <view class="dropdown-item" @click="toggleDropdown('cuisines')">
        <text>Cuisines</text>
        <text class="dropdown-icon">〉</text>
      </view>
      <view class="dropdown-item" @click="toggleDropdown('price')">
        <text>Price</text>
        <text class="dropdown-icon">〉</text>
      </view>
      <view class="dropdown-item" @click="toggleDropdown('offers')">
        <text>Offers</text>
        <text class="dropdown-icon">〉</text>
      </view>
      <view class="dropdown-item" @click="toggleDropdown('specialOptions')">
        <text>Special options</text>
        <text class="dropdown-icon">〉</text>
      </view>
      <view class="dropdown-item" @click="toggleDropdown('seatingOptions')">
        <text>Seating options</text>
        <text class="dropdown-icon">〉</text>
      </view>
    </view>
    <view class="results-btn" @tap="doSearch">
      <text>开始搜索</text>
    </view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      activeDropdown: '',
      sortOptions: ['Featured', 'Distance', 'Newest', 'Ratings'],
      selectedSort: 'Featured',
      distanceOptions: ['Auto', '1', '4', '16', '40', '80', '90'],
      selectedDistance: 'Auto',
      resultCount: 56
    }
  },
  methods: {
    doSearch() {
      const eventChannel = this.getOpenerEventChannel();
      eventChannel.emit('doSearch', { selectedOption: 'Option 1' });
      uni.navigateBack();
    }
  }
}
</script>

<style>
.filter-container {
  padding: 0 20rpx;
  background-color: #ffffff;
  min-height: 100vh;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20rpx 30rpx;
  background-color: #ffffff;
  z-index: 1;
}

.back-btn {
  width: 60rpx;
  height: 60rpx;
}

.title {
  font-size: 36rpx;
  font-weight: bold;
  margin-left: 20rpx;
}

.description {
  margin-bottom: 30rpx;
}

.description-text {
  color: #999999;
  font-size: 28rpx;
}

.section {
  margin-bottom: 30rpx;
}

.section-title {
  font-size: 32rpx;
  font-weight: bold;
  margin-bottom: 20rpx;
}

.option-pills {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
}

.pill {
  background-color: #f5f5f5;
  border-radius: 40rpx;
  padding: 12rpx 30rpx;
  margin-right: 20rpx;
  margin-bottom: 20rpx;
}

.pill.active {
  background-color: #eeeeee;
}

.dropdown-section {
  margin-top: 20rpx;
}

.dropdown-item {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  padding: 30rpx 0;
  border-bottom: 1px solid #f0f0f0;
}

.dropdown-icon {
  color: #cccccc;
  transform: rotate(90deg);
}

.results-btn {
  position: fixed;
  bottom: 40rpx;
  left: 20rpx;
  right: 20rpx;
  background-color: var(--color-primary);
  border-radius: 9999rpx;
  padding: 30rpx 0;
  font-size: 16px;
  width: 80%;
  margin: auto;
  text-align: center;
}

.results-btn text {
  color: #ffffff;
  font-size: 32rpx;
  font-weight: bold;
}
</style>