<template>
  <view class="checkout-container">
    <!-- Map placeholder -->
    <view class="map-placeholder">
      <text class="map-text">Map</text>
    </view>
    
    <!-- Delivery info -->
    <view class="section delivery-info">
      <view class="section-title">Your Delivery</view>
      <view class="address-row">
        <text class="icon-location">📍</text>
        <text class="address">13485, 71 Ave, Surrey BC V3W 2K6</text>
      </view>
      <view class="delivery-time">
        <view class="delivery-option selected">
          <text class="icon-clock">🕒</text>
          <text class="option-text">ASAP</text>
        </view>
        <view class="delivery-option">
          <text class="icon-calendar">📅</text>
          <text class="option-text">Schedule</text>
        </view>
      </view>
    </view>
    
    <!-- Divider -->
    <view class="divider"></view>
    
    <!-- Drop-off options -->
    <view class="section">
      <view class="section-title">Drop-off Options</view>
      <view class="options-grid">
        <view class="option-button selected">
          <text>Hand it to me</text>
        </view>
        <view class="option-button">
          <text>Leave at the door</text>
        </view>
      </view>
      <view class="note-input">
        <text>Beware of the dog</text>
      </view>
    </view>
    
    <!-- Divider -->
    <view class="divider"></view>
    
    <!-- Tip section -->
    <view class="section">
      <view class="section-title">Tip your courier</view>
      <view class="tip-description">
        <text>Your tip can be a great contribution fulfilling their wish.</text>
      </view>
      <view class="tip-options">
        <view class="tip-button" :class="{ selected: tipAmount === 2 }">
          <text>$2.00</text>
        </view>
        <view class="tip-button" :class="{ selected: tipAmount === 3 }">
          <text>$3.00</text>
        </view>
        <view class="tip-button" :class="{ selected: tipAmount === 4 }">
          <text>$4.00</text>
        </view>
        <view class="tip-custom">
          <text class="dollar-sign">$</text>
          <input type="text" v-model="customTip" class="tip-input" />
        </view>
      </view>
    </view>
    
    <!-- Points section -->
    <view class="section points-section">
      <view class="points-row">
        <text>Use your points</text>
        <view class="radio-options">
          <view class="radio-option">
            <radio checked="true" color="#888888" />
            <text>Yes</text>
          </view>
          <view class="radio-option">
            <radio color="#888888" />
            <text>No</text>
          </view>
        </view>
      </view>
    </view>
    
    <!-- Voucher section -->
    <view class="section voucher-section">
      <view class="voucher-row">
        <text>Add Voucher/Offer</text>
        <input type="text" placeholder="Voucher/Offer code" class="voucher-input" />
      </view>
    </view>
    
    <!-- Divider -->
    <view class="divider"></view>
    
    <!-- Order summary -->
    <view class="section order-summary">
      <view class="summary-header">
        <view class="summary-title">
          <text class="icon-list">☰</text>
          <text>View Order</text>
        </view>
        <text class="icon-dropdown">▼</text>
      </view>
      
      <view class="summary-items">
        <view class="summary-item">
          <text>Subtotal</text>
          <text>$26.35</text>
        </view>
        <view class="summary-item">
          <text>Delivery Fee</text>
          <view class="fee-container">
            <text class="fee-strike">-$1.49</text>
            <text class="fee-free">FREE</text>
          </view>
        </view>
        <view class="summary-item">
          <text>Courier Tip</text>
          <text>$6.09</text>
        </view>
        <view class="summary-item">
          <text>Bag Fee incl. GST/PST 2 cents/5¢</text>
          <text>$0.20</text>
        </view>
        <view class="summary-item">
          <text>Service Fee Tax - GST</text>
          <text>$0.10</text>
        </view>
      </view>
      
      <view class="total-row">
        <text class="total-text">Total</text>
        <text class="total-amount">$37.51</text>
      </view>
    </view>
    <view class="bottom gx-d-flex">
      <view class="pay-button">
        <text>Proceed to Pay</text>
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
      tipAmount: 4,
      customTip: '',
      usePoints: true,
      voucherCode: '',
      orderSummary: {
        subtotal: 26.35,
        deliveryFee: 1.49, // Crossed out
        courierTip: 6.09,
        bagFee: 0.20,
        serviceFee: 0.10,
        total: 37.51
      }
    };
  },
  methods: {
    selectTipOption(amount) {
      this.tipAmount = amount;
      this.customTip = '';
    },
    proceedToPayment() {
      // Handle payment processing
      uni.showLoading({
        title: 'Processing...'
      });
      
      setTimeout(() => {
        uni.hideLoading();
        uni.showToast({
          title: 'Payment successful!',
          icon: 'success'
        });
      }, 1500);
    }
  }
};
</script>

<style>
.bottom {
  position:fixed;
  bottom:0;
  width:100%;
  height:160rpx;
  background:lightgray;
  align-items:center;
  justify-content: space-around;
}

.checkout-container {
  background-color: #ffffff;
  min-height: 100vh;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
  padding-bottom:160rpx;
}

.status-bar {
  display: flex;
  justify-content: space-between;
  padding: 8px 16px;
}

.time {
  font-weight: bold;
}

.status-icons {
  display: flex;
  gap: 8px;
}

.header {
  display: flex;
  align-items: center;
  padding: 16px;
}

.back-button {
  margin-right: 16px;
}

.back-icon {
  font-size: 24px;
  color: #333333;
}

.title {
  font-size: 20px;
  font-weight: bold;
  color: #333333;
}

.map-placeholder {
  background-color: #f0f0f0;
  height: 120px;
  display: flex;
  justify-content: center;
  align-items: center;
}

.map-text {
  color: #888888;
  font-size: 16px;
}

.section {
  padding: 16px;
}

.section-title {
  font-size: 16px;
  font-weight: bold;
  color: #333333;
  margin-bottom: 8px;
}

.address-row {
  display: flex;
  align-items: center;
  margin-bottom: 12px;
}

.icon-location {
  margin-right: 8px;
  font-size: 18px;
}

.address {
  font-size: 14px;
  color: #333333;
}

.delivery-time {
  display: flex;
  gap: 16px;
}

.delivery-option {
  display: flex;
  align-items: center;
  padding: 8px 12px;
  border-radius: 4px;
  background-color: #f0f0f0;
}

.delivery-option.selected {
  background-color: #e0e0e0;
}

.icon-clock, .icon-calendar {
  margin-right: 8px;
  font-size: 16px;
}

.option-text {
  font-size: 14px;
  color: #333333;
}

.divider {
  height: 1px;
  background-color: #e0e0e0;
}

.options-grid {
  display: flex;
  gap: 8px;
  margin-bottom: 12px;
}

.option-button {
  flex: 1;
  padding: 12px;
  border-radius: 4px;
  background-color: #f0f0f0;
  display: flex;
  justify-content: center;
  align-items: center;
}

.option-button.selected {
  background-color: #888888;
  color: #ffffff;
}

.note-input {
  padding: 16px;
  background-color: #f0f0f0;
  border-radius: 4px;
  font-size: 14px;
  color: #888888;
}

.tip-description {
  font-size: 14px;
  color: #666666;
  margin-bottom: 12px;
}

.tip-options {
  display: flex;
  gap: 8px;
}

.tip-button {
  flex: 1;
  padding: 12px;
  border-radius: 4px;
  background-color: #f0f0f0;
  display: flex;
  justify-content: center;
  align-items: center;
}

.tip-button.selected {
  background-color: #f0f0f0;
  border: 2px solid #333333;
}

.tip-custom {
  flex: 1;
  display: flex;
  align-items: center;
  background-color: #ffffff;
  border: 1px solid #e0e0e0;
  border-radius: 4px;
  padding: 0 12px;
}

.dollar-sign {
  color: #333333;
  margin-right: 4px;
}

.tip-input {
  flex: 1;
  height: 40px;
  border: none;
  font-size: 14px;
}

.points-section, .voucher-section {
  padding-top: 8px;
  padding-bottom: 8px;
}

.points-row, .voucher-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.radio-options {
  display: flex;
  gap: 16px;
}

.radio-option {
  display: flex;
  align-items: center;
  gap: 4px;
}

.voucher-input {
  width: 180px;
  height: 36px;
  border: 1px solid #e0e0e0;
  border-radius: 4px;
  padding: 0 12px;
  font-size: 14px;
}

.summary-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.summary-title {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 16px;
  font-weight: bold;
}

.icon-list {
  font-size: 18px;
}

.icon-dropdown {
  font-size: 12px;
}

.summary-items {
  margin-bottom: 16px;
}

.summary-item {
  display: flex;
  justify-content: space-between;
  margin-bottom: 8px;
  font-size: 14px;
}

.fee-container {
  display: flex;
  gap: 8px;
  align-items: center;
}

.fee-strike {
  text-decoration: line-through;
  color: #888888;
}

.fee-free {
  color: #008000;
  font-weight: bold;
}

.total-row {
  display: flex;
  justify-content: space-between;
  padding-top: 12px;
  border-top: 1px solid #e0e0e0;
}

.total-text {
  font-size: 16px;
  font-weight: bold;
}

.total-amount {
  font-size: 16px;
  font-weight: bold;
}

.pay-button {
  margin: 16px;
  padding: 16px;
  background-color: #888888;
  color: #ffffff;
  border-radius: 4px;
  display: flex;
  justify-content: center;
  align-items: center;
  font-size: 16px;
  font-weight: bold;
}
</style>