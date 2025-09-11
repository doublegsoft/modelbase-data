<template>
  <view class="container">
    <!-- Header with back button and bookmark -->
    <view class="header">
      <view class="back-icon" @click="goBack">
        <text class="icon">&#xe60e;</text>
      </view>
      <view class="title">News Detail</view>
      <view class="bookmark-icon" @click="toggleBookmark">
        <text class="icon" :class="{ 'active': isBookmarked }">&#xe67c;</text>
      </view>
    </view>
    
    <!-- News image -->
    <image class="news-image" src="/static/cricket-match.jpg" mode="aspectFill"></image>
    
    <!-- Author info -->
    <view class="author-container">
      <view class="author-info">
        <image class="author-avatar" src="/static/avatar.jpg" mode="aspectFill"></image>
        <text class="author-name">Anushka jaan</text>
      </view>
      <view class="likes">
        <text class="icon heart">&#xe68f;</text>
        <text class="like-count">204</text>
      </view>
    </view>
    
    <!-- Article metadata -->
    <view class="article-meta">
      <text class="read-time">8 min read · Updated: 12 Jun 2024, 11:38 PM IST</text>
    </view>
    
    <!-- Article title -->
    <view class="article-title">
      <text>India vs USA Highlights: Suryakumar Yadav's stunning half-century lead IND to T20 World Cup 2024 Super 8 stage</text>
    </view>
    
    <!-- Article content -->
    <view class="article-content">
      <text class="content-text">
        India vs USA Live Score: United States just missed a big wicket as Saurabh Nethravalkar dropped Suryakumar Yadav, and this can turn very costly! SKY has been one of the most aggressive players in T20 cricket.
        
        India vs USA Live Score Updates: United States' Saurabh Nethravalkar celebrates the dismissal of India's Virat Kohli during the ICC Men's T20 World Cup cricket match between United States and India at the Nassau County International Cricket Stadium in Westbury, New York USA.
        
        United States scored 110-runs against India at the Nassau International Cricket Stadium in New York on Wednesday as Arshdeep Singh and Hardik Pandya delivered a beautiful spell to clinch multiple wickets. Rohit Sharma-led India chose to bowl after winning the toss at the New York stadium on Wednesday. 
        
        India will lock horns against the USA today i.e. June 12 in the T20 World Cup 2024 match at the Nassau County International Cricket Stadium in New York. In the matches played so far, the USA has played some really fine cricket in their debut World Cup. First, they blew Canada away by pulling off a 195-run chase in the tournament opener with 14 balls left. Then, they almost pulled off a run-chase of 160 runs against Pakistan, but the match was tied and USA won the game in the 'Super Over' while defending 19 runs.
      </text>
    </view>
    
    <!-- Comment section -->
    <view class="comment-section">
      <text class="view-comment">View Comment</text>
    </view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      isBookmarked: false
    }
  },
  methods: {
    goBack() {
      uni.navigateBack({
        delta: 1
      });
    },
    toggleBookmark() {
      this.isBookmarked = !this.isBookmarked;
      uni.showToast({
        title: this.isBookmarked ? 'Added to bookmarks' : 'Removed from bookmarks',
        icon: 'none'
      });
    }
  }
}
</script>

<style>
.container {
  padding-bottom: 30rpx;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20rpx 30rpx;
  position: relative;
}

.title {
  font-size: 36rpx;
  font-weight: bold;
}

.icon {
  font-family: "uniicons";
  font-size: 44rpx;
}

.back-icon, .bookmark-icon {
  width: 60rpx;
  height: 60rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.active {
  color: #007AFF;
}

.news-image {
  width: 100%;
  height: 400rpx;
  border-radius: 8rpx;
}

.author-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20rpx 30rpx;
}

.author-info {
  display: flex;
  align-items: center;
}

.author-avatar {
  width: 60rpx;
  height: 60rpx;
  border-radius: 30rpx;
  margin-right: 15rpx;
}

.author-name {
  font-size: 28rpx;
  font-weight: bold;
}

.likes {
  display: flex;
  align-items: center;
}

.heart {
  color: #FF5252;
  margin-right: 5rpx;
}

.like-count {
  font-size: 28rpx;
  color: #666;
}

.article-meta {
  padding: 0 30rpx;
  margin-bottom: 10rpx;
}

.read-time {
  font-size: 24rpx;
  color: #666;
}

.article-title {
  padding: 10rpx 30rpx;
  margin-bottom: 20rpx;
}

.article-title text {
  font-size: 36rpx;
  font-weight: bold;
  line-height: 1.4;
}

.article-content {
  padding: 0 30rpx;
}

.content-text {
  font-size: 30rpx;
  line-height: 1.6;
  color: #333;
}

.comment-section {
  margin-top: 40rpx;
  padding: 0 30rpx;
  text-align: center;
}

.view-comment {
  font-size: 28rpx;
  color: #007AFF;
}
</style>