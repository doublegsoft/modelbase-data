<template>
  <view class="quiz-container">
    <!-- Header -->
    <view class="header">
      <view class="header-left">
        <text class="back-icon">←</text>
        <text class="header-title">UI UX Design Quiz</text>
      </view>
      <view class="timer">
        <text class="timer-icon">⏱</text>
        <text class="timer-text">16:35</text>
      </view>
    </view>
    <view class="progress-container">
      <view class="progress-bar">
        <view class="progress-filled" :style="{width: '90%'}"></view>
      </view>
      <view class="question-indicators">
        <view v-for="i in 7" :key="i" class="indicator" :class="{'active': i === 7}">
          <text>{{ i + 3 }}</text>
        </view>
      </view>
      <view class="bottom-line">
        <view class="bottom-line-filled" :style="{width: '90%'}"></view>
      </view>
    </view>
    
    <!-- Question -->
    <view class="question-container">
      <text class="question-text">What is the meaning of UI UX Design ?</text>
    </view>
    
    <!-- Answer Options -->
    <view class="options-container">
      <view class="option" v-for="(option, index) in options" :key="index" 
        :class="{'selected': selectedOption === index}"
        @tap="selectOption(index)">
        <view class="option-circle">
          <text>{{ option.label }}</text>
        </view>
        <text class="option-text">{{ option.text }}</text>
      </view>
    </view>
    
    <!-- Navigation Controls -->
    <view class="navigation-controls">
      <view class="nav-button prev">
        <text class="nav-icon">◀</text>
      </view>
      <view class="submit-button">
        <text>Submit Quiz</text>
      </view>
      <view class="nav-button next">
        <text class="nav-icon">▶</text>
      </view>
    </view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      currentQuestion: 10,
      totalQuestions: 10,
      selectedOption: 3, // D is selected in the image
      timeLeft: '16:35',
      options: [
        {
          label: 'A',
          text: 'User Interface and User Experience'
        },
        {
          label: 'B',
          text: 'User Introface and User Experience'
        },
        {
          label: 'C',
          text: 'User Interfice and Using Experience'
        },
        {
          label: 'D',
          text: 'User Interface and User Experience'
        },
        {
          label: 'E',
          text: 'Using Interface and Using Experience'
        }
      ]
    };
  },
  methods: {
    selectOption(index) {
      this.selectedOption = index;
    },
    prevQuestion() {
      // Handle previous question logic
    },
    nextQuestion() {
      // Handle next question logic
    },
    submitQuiz() {
      // Handle quiz submission
      uni.showLoading({
        title: 'Submitting...'
      });
      
      setTimeout(() => {
        uni.hideLoading();
        uni.showToast({
          title: 'Quiz submitted successfully!',
          icon: 'success'
        });
      }, 1000);
    }
  }
};
</script>

<style>
.quiz-container {
  display: flex;
  flex-direction: column;
  height: 100vh;
  background-color: #f5f5f5;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px;
  background-color: #2196F3;
  color: white;
}

.header-left {
  display: flex;
  align-items: center;
}

.back-icon {
  font-size: 20px;
  margin-right: 12px;
}

.header-title {
  font-size: 18px;
  font-weight: bold;
}

.timer {
  display: flex;
  align-items: center;
  background-color: white;
  border-radius: 16px;
  padding: 4px 12px;
}

.timer-icon {
  font-size: 16px;
  color: #2196F3;
  margin-right: 4px;
}

.timer-text {
  color: #2196F3;
  font-size: 14px;
  font-weight: bold;
}

.progress-container {
  background-color: white;
  border-bottom-left-radius: 24px;
  border-bottom-right-radius: 24px;
  padding: 0 16px 16px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
}

.progress-bar {
  height: 4px;
  background-color: #EEEEEE;
  border-radius: 2px;
  margin-bottom: 16px;
}

.progress-filled {
  height: 100%;
  background-color: #2196F3;
  border-radius: 2px;
}

.question-indicators {
  display: flex;
  justify-content: space-between;
  margin-bottom: 16px;
}

.indicator {
  width: 32px;
  height: 32px;
  border-radius: 16px;
  background-color: #DDDDDD;
  display: flex;
  justify-content: center;
  align-items: center;
}

.indicator text {
  color: #666666;
  font-size: 14px;
}

.indicator.active {
  background-color: #2196F3;
}

.indicator.active text {
  color: white;
}

.bottom-line {
  height: 4px;
  background-color: #EEEEEE;
  border-radius: 2px;
}

.bottom-line-filled {
  height: 100%;
  background-color: #2196F3;
  border-radius: 2px;
}

.question-container {
  padding: 24px 16px;
}

.question-text {
  font-size: 18px;
  font-weight: bold;
  color: #333333;
}

.options-container {
  padding: 0 16px;
}

.option {
  display: flex;
  align-items: center;
  margin-bottom: 16px;
}

.option-circle {
  width: 40px;
  height: 40px;
  border-radius: 20px;
  background-color: #DDDDDD;
  display: flex;
  justify-content: center;
  align-items: center;
  margin-right: 16px;
}

.option-circle text {
  font-size: 16px;
  color: #666666;
}

.option.selected .option-circle {
  background-color: #2196F3;
}

.option.selected .option-circle text {
  color: white;
}

.option-text {
  font-size: 16px;
  color: #333333;
}

.navigation-controls {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px;
  margin-top: auto;
}

.nav-button {
  width: 48px;
  height: 48px;
  border-radius: 24px;
  background-color: #2196F3;
  display: flex;
  justify-content: center;
  align-items: center;
}

.nav-icon {
  color: white;
  font-size: 18px;
}

.submit-button {
  background-color: white;
  border: 1px solid #2196F3;
  border-radius: 4px;
  padding: 12px 24px;
}

.submit-button text {
  color: #2196F3;
  font-size: 16px;
}

.prev {
  background-color: white;
}

.prev .nav-icon {
  color: #2196F3;
}
</style>