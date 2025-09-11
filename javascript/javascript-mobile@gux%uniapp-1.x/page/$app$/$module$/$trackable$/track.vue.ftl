<template>
  <view class="container">
    <map
      id="map"
      class="map"
      :latitude="latitude"
      :longitude="longitude"
      :markers="markers"
      :polyline="polyline"
      :scale="16"
      show-location
    ></map>
    
    <view class="search-box">
      <view class="avatar">
        <image src="/static/avatar.png" mode="aspectFill"></image>
      </view>
      <input
        class="search-input"
        type="text"
        placeholder="Where are you going to?"
        @focus="onSearchFocus"
      />
      <view class="action-buttons">
        <view class="action-button">
          <text class="iconfont icon-sound"></text>
        </view>
        <view class="action-button">
          <text class="iconfont icon-music"></text>
        </view>
      </view>
    </view>
    
    <view class="bottom-bar">
      <view class="search-icon">
        <text class="iconfont icon-search"></text>
      </view>
      <view class="mic-icon">
        <text class="iconfont icon-mic"></text>
      </view>
    </view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      latitude: 37.773972,
      longitude: -122.431297,
      markers: [
        {
          id: 1,
          latitude: 37.773972,
          longitude: -122.431297,
          iconPath: '/static/marker.png',
          width: 30,
          height: 30
        },
        {
          id: 2,
          latitude: 37.778972,
          longitude: -122.437297,
          iconPath: '/static/destination.png',
          width: 30,
          height: 30
        }
      ],
      polyline: [{
        points: [
          {
            latitude: 37.773972,
            longitude: -122.431297
          },
          {
            latitude: 37.775972,
            longitude: -122.433297
          },
          {
            latitude: 37.776972,
            longitude: -122.435297
          },
          {
            latitude: 37.778972,
            longitude: -122.437297
          }
        ],
        color: '#1890FF',
        width: 5
      }]
    };
  },
  onLoad() {
    // Get user's location when app loads
    uni.getLocation({
      type: 'gcj02',
      success: (res) => {
        this.latitude = res.latitude;
        this.longitude = res.longitude;
        // Update the marker for current location
        this.markers[0].latitude = res.latitude;
        this.markers[0].longitude = res.longitude;
      },
      fail: () => {
        uni.showToast({
          title: 'Failed to get location',
          icon: 'none'
        });
      }
    });
  },
  methods: {
    onSearchFocus() {
      uni.navigateTo({
        url: '/pages/search/search'
      });
    }
  }
};
</script>

<style>
.container {
  width: 100%;
  height: 100vh;
  position: relative;
}

.map {
  width: 100%;
  height: 100%;
}

.search-box {
  position: absolute;
  top: 40rpx;
  left: 30rpx;
  right: 30rpx;
  height: 100rpx;
  background-color: #FFFFFF;
  border-radius: 50rpx;
  display: flex;
  align-items: center;
  padding: 0 20rpx;
  box-shadow: 0 2rpx 10rpx rgba(0, 0, 0, 0.1);
}

.avatar {
  width: 60rpx;
  height: 60rpx;
  border-radius: 30rpx;
  overflow: hidden;
  margin-right: 20rpx;
}

.avatar image {
  width: 100%;
  height: 100%;
}

.search-input {
  flex: 1;
  height: 80rpx;
  font-size: 28rpx;
}

.action-buttons {
  display: flex;
}

.action-button {
  width: 60rpx;
  height: 60rpx;
  display: flex;
  justify-content: center;
  align-items: center;
  margin-left: 10rpx;
}

.bottom-bar {
  position: absolute;
  bottom: 40rpx;
  left: 30rpx;
  right: 30rpx;
  height: 100rpx;
  display: flex;
  justify-content: space-between;
}

.search-icon, .mic-icon {
  width: 100rpx;
  height: 100rpx;
  background-color: #FFFFFF;
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
  box-shadow: 0 2rpx 10rpx rgba(0, 0, 0, 0.1);
}

/* Add iconfont style */
@font-face {
  font-family: "iconfont";
  src: url('data:application/x-font-woff2;charset=utf-8;base64,...'); /* You would add actual font data here */
}

.iconfont {
  font-family: "iconfont" !important;
  font-size: 24px;
  font-style: normal;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

.icon-search:before {
  content: "\e600";
}

.icon-mic:before {
  content: "\e601";
}

.icon-sound:before {
  content: "\e602";
}

.icon-music:before {
  content: "\e603";
}
</style>