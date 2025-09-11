<template>
  <view class="chat-container">
    <!-- Status bar -->
    <view class="status-bar">
      <text class="time">9:30</text>
      <view class="status-icons">
        <text class="icon-signal">▲</text>
        <text class="icon-battery">▇</text>
      </view>
    </view>
    
    <!-- Chat header -->
    <view class="chat-header">
      <view class="header-left">
        <view class="back-button">
          <text class="back-icon">←</text>
        </view>
        <text class="chat-name">Bryan</text>
      </view>
      <view class="header-right">
        <view class="header-icon">
          <text class="icon-call">📞</text>
        </view>
        <view class="header-icon">
          <text class="icon-search">🔍</text>
        </view>
        <view class="header-icon">
          <text class="icon-more">⋮</text>
        </view>
      </view>
    </view>
    
    <!-- Chat messages -->
    <scroll-view scroll-y class="chat-messages">
      <view class="message-group">
        <view class="message incoming">
          <image class="avatar" src="/static/avatar.jpg" mode="aspectFill"></image>
          <view class="message-bubble">
            <text class="message-text">Looking forward to the trip.</text>
          </view>
        </view>
        <view class="message outgoing">
          <view class="message-bubble">
            <text class="message-text">Same! Can't wait.</text>
          </view>
        </view>
        <view class="timestamp">
          <text>Today 8:43 AM</text>
        </view>
      </view>
      
      <view class="message-group">
        <view class="message incoming">
          <image class="avatar" src="/static/avatar.jpg" mode="aspectFill"></image>
          <view class="message-content">
            <view class="shared-image">
              <image src="/static/antelope-canyon.jpg" mode="aspectFill" class="shared-image-content"></image>
            </view>
            <view class="shared-link">
              <text class="shared-link-title">Antelope Canyon guide tour</text>
              <text class="shared-link-url">airbnb.com</text>
            </view>
          </view>
        </view>
        
        <view class="message incoming">
          <image class="avatar" src="/static/avatar.jpg" mode="aspectFill"></image>
          <view class="message-bubble">
            <text class="message-text">What do you think?</text>
          </view>
        </view>
        
        <view class="message outgoing">
          <view class="message-bubble">
            <text class="message-text">Oh yes this looks great!</text>
          </view>
        </view>
      </view>
    </scroll-view>
    
    <!-- Message input -->
    <view class="message-input-container">
      <view class="message-input-wrapper">
        <view class="input-icon">
          <text class="icon-attach">📷</text>
        </view>
        <view class="input-icon">
          <text class="icon-photo">🖼️</text>
        </view>
        <input class="message-input" type="text" placeholder="Message" />
      </view>
    </view>
    
    <!-- Navigation bar -->
    <view class="navigation-bar">
      <view class="nav-indicator"></view>
    </view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      messages: [
        {
          id: 1,
          sender: 'Bryan',
          content: 'Looking forward to the trip.',
          timestamp: 'Today 8:43 AM',
          type: 'text',
          isOutgoing: false
        },
        {
          id: 2,
          content: 'Same! Can\'t wait.',
          timestamp: 'Today 8:43 AM',
          type: 'text',
          isOutgoing: true
        },
        {
          id: 3,
          sender: 'Bryan',
          content: {
            image: '/static/antelope-canyon.jpg',
            title: 'Antelope Canyon guide tour',
            url: 'airbnb.com'
          },
          timestamp: 'Today 8:45 AM',
          type: 'link',
          isOutgoing: false
        },
        {
          id: 4,
          sender: 'Bryan',
          content: 'What do you think?',
          timestamp: 'Today 8:45 AM',
          type: 'text',
          isOutgoing: false
        },
        {
          id: 5,
          content: 'Oh yes this looks great!',
          timestamp: 'Today 8:46 AM',
          type: 'text',
          isOutgoing: true
        }
      ]
    };
  },
  methods: {
    sendMessage(message) {
      // Implementation for sending message
    }
  }
};
</script>

<style>
.chat-container {
  display: flex;
  flex-direction: column;
  height: 100vh;
  background-color: #f8f9fa;
}

.status-bar {
  display: flex;
  justify-content: space-between;
  padding: 10px 16px;
  background-color: #f8f9fa;
}

.time {
  font-size: 14px;
  font-weight: bold;
}

.status-icons {
  display: flex;
}

.icon-signal, .icon-battery {
  margin-left: 8px;
}

.chat-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  background-color: #f8f9fa;
  border-bottom: 1px solid #e8e8e8;
}

.header-left {
  display: flex;
  align-items: center;
}

.back-button {
  margin-right: 16px;
}

.chat-name {
  font-size: 18px;
  font-weight: bold;
}

.header-right {
  display: flex;
}

.header-icon {
  margin-left: 20px;
}

.chat-messages {
  flex: 1;
  padding: 16px;
}

.message-group {
  margin-bottom: 16px;
}

.message {
  display: flex;
  margin-bottom: 8px;
}

.avatar {
  width: 36px;
  height: 36px;
  border-radius: 18px;
  margin-right: 8px;
}

.message-bubble {
  padding: 12px 16px;
  border-radius: 18px;
  max-width: 70%;
}

.incoming .message-bubble {
  background-color: #f0f0f0;
}

.outgoing {
  justify-content: flex-end;
}

.outgoing .message-bubble {
  background-color: #1976d2;
  color: white;
}

.message-text {
  font-size: 16px;
  line-height: 1.4;
}

.timestamp {
  text-align: center;
  margin: 16px 0;
}

.timestamp text {
  font-size: 12px;
  color: #777;
}

.message-content {
  display: flex;
  flex-direction: column;
  max-width: 70%;
}

.shared-image {
  border-radius: 12px;
  overflow: hidden;
  margin-bottom: 4px;
}

.shared-image-content {
  width: 100%;
  height: 140px;
}

.shared-link {
  background-color: #f0f0f0;
  padding: 8px 12px;
  border-radius: 12px;
}

.shared-link-title {
  font-size: 14px;
  font-weight: bold;
}

.shared-link-url {
  font-size: 12px;
  color: #777;
}

.message-input-container {
  padding: 12px 16px;
  background-color: #f8f9fa;
}

.message-input-wrapper {
  display: flex;
  align-items: center;
  background-color: white;
  border-radius: 24px;
  padding: 8px 16px;
}

.input-icon {
  margin-right: 8px;
}

.message-input {
  flex: 1;
  height: 36px;
  border: none;
  font-size: 16px;
}

.navigation-bar {
  height: 24px;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: #f8f9fa;
}

.nav-indicator {
  width: 30%;
  height: 4px;
  background-color: #ddd;
  border-radius: 2px;
}
</style>