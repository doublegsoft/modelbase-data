<template>
  <view class="profile-container">
    <view class="form-section">
      <view class="form-item">
        <text class="label">姓名</text>
        <input class="input" v-model="form.name" placeholder="your name" />
      </view>
      <view class="divider"></view>
      <view class="form-item">
        <text class="label">电话</text>
        <input class="input" v-model="form.email" placeholder="yourname@gmail.com" />
      </view>
      <view class="divider"></view>
      <view class="form-item">
        <text class="label">出生日期</text>
        <input class="input" v-model="form.mobile" placeholder="Add number" />
      </view>
      <view class="divider"></view>
      <view class="form-item">
        <text class="label">住址</text>
        <input class="input" v-model="form.location" placeholder="USA" />
      </view>
      <view class="divider"></view>
    </view>
    
    <!-- Save button -->
    <button class="save-button" @tap="handleSave">保存</button>
  </view>
</template>

<script>
export default {
  data() {
    return {
      userInfo: {
        avatar: '/static/images/avatar.png',
        name: 'Your name',
        email: 'yourname@gmail.com'
      },
      form: {
        name: 'your name',
        email: 'yourname@gmail.com',
        mobile: '',
        location: 'USA'
      }
    }
  },
  methods: {
    handleClose() {
      uni.navigateBack({
        delta: 1
      })
    },
    handleSave() {
      // Validation could be added here
      uni.showLoading({
        title: 'Saving...'
      })
      
      // Simulate API call
      setTimeout(() => {
        uni.hideLoading()
        uni.showToast({
          title: 'Profile updated successfully',
          icon: 'success'
        })
        
        // Update the header info
        this.userInfo.name = this.form.name
        this.userInfo.email = this.form.email
      }, 1000)
    }
  }
}
</script>

<style>
.profile-container {
  padding: 20px;
  background-color: #ffffff;
  min-height: 100vh;
}

.header {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.user-info {
  display: flex;
  flex-direction: row;
  align-items: center;
}

.user-details {
  display: flex;
  flex-direction: column;
}

.name {
  font-size: 18px;
  font-weight: bold;
}

.email {
  font-size: 14px;
  color: #666;
}

.close-icon {
  font-size: 24px;
  font-weight: bold;
  padding: 10px;
}

.divider {
  height: 1px;
  background-color: #eeeeee;
  margin: 15px 0 15px 0;
}

.form-section {
  margin-bottom: 30px;
}

.form-item {
  display: flex;
}

.label {
  width: 100px;
  font-size: 16px;
  color: #333;
}

.input {
  height: 20px;
  width: calc(100% - 100px);
  margin-left: auto;
  border: none;
  background-color: #fff;
  font-size: 16px;
  color: #333;
}

.save-button {
  background-color: #2196F3;
  color: white;
  height: 45px;
  line-height: 45px;
  border-radius: 9999px;
  font-size: 16px;
  text-align: center;
}
</style>
