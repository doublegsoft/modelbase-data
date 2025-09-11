<template>
  <view class="review-container">
    <view class="review-header">
      <text class="review-title">WRITE YOUR REVIEW</text>
    </view>
    
    <view class="star-rating">
      <view 
        v-for="star in 5" 
        :key="star" 
        class="star"
        @tap="setRating(star)"
      >
        <text 
          class="star-icon" 
          :class="{ 'star-filled': star <= rating }"
        >★</text>
      </view>
    </view>
    
    <view class="review-input-container">
      <textarea 
        class="review-input" 
        v-model="reviewText" 
        placeholder="Write your review" 
        placeholder-class="review-placeholder"
      />
    </view>
    
    <view class="submit-button-container">
      <button 
        class="submit-button" 
        @tap="submitReview"
        :disabled="!isValid"
      >POST REVIEW</button>
    </view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      rating: 3,
      reviewText: '',
      isSubmitting: false
    };
  },
  computed: {
    isValid() {
      return this.rating > 0 && this.reviewText.trim().length > 0;
    }
  },
  methods: {
    setRating(value) {
      this.rating = value;
    },
    submitReview() {
      if (!this.isValid) return;
      
      this.isSubmitting = true;
      
      // Here you would typically send the review to your API
      uni.showLoading({
        title: 'Submitting...'
      });
      
      // Simulate API call
      setTimeout(() => {
        uni.hideLoading();
        
        uni.showToast({
          title: 'Review submitted!',
          icon: 'success'
        });
        
        // Reset form after successful submission
        this.reviewText = '';
        this.isSubmitting = false;
        
        // Emit event to parent component
        this.$emit('review-submitted', {
          rating: this.rating,
          review: this.reviewText
        });
      }, 1000);
    }
  }
};
</script>

<style>
.review-container {
  padding: 20px;
  display: flex;
  flex-direction: column;
  background-color: #ffffff;
}

.review-header {
  display: flex;
  justify-content: center;
  margin-bottom: 20px;
}

.review-title {
  font-size: 18px;
  font-weight: bold;
  text-align: center;
}

.star-rating {
  display: flex;
  justify-content: center;
  margin-bottom: 20px;
}

.star {
  padding: 0 5px;
}

.star-icon {
  font-size: 30px;
  color: #E0E0E0;
}

.star-filled {
  color: #FFD700;
}

.review-input-container {
  margin-bottom: 20px;
}

.review-input {
  width: 100%;
  height: 100px;
  padding: 15px;
  background-color: #F8F9FA;
  border-radius: 8px;
  border: none;
  font-size: 16px;
}

.review-placeholder {
  color: #8F8F8F;
}

.submit-button-container {
  margin-top: 10px;
}

.submit-button {
  width: 100%;
  height: 50px;
  background-color: #000000;
  color: #FFFFFF;
  font-weight: bold;
  border-radius: 5px;
  font-size: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.submit-button:active {
  opacity: 0.8;
}

.submit-button[disabled] {
  background-color: #CCCCCC;
  color: #666666;
}
</style>