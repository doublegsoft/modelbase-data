@import "/app.wxss";

.container {
  padding-bottom: 120rpx;
}

.product-image {
  width: 100%;
  height: 750rpx;
}

.price-section {
  padding: 30rpx;
}

.price {
  font-size: 36rpx;
  font-weight: bold;
}

.description {
  font-size: 28rpx;
  color: #666;
  margin-top: 10rpx;
}

.variations {
  padding: 30rpx;
}

.section-title {
  font-size: 32rpx;
  font-weight: bold;
  margin-bottom: 20rpx;
}

.variation-scroll {
  white-space: nowrap;
}

.variation-items {
  display: flex;
}

.variation-item {
  width: 160rpx;
  height: 160rpx;
  margin-right: 20rpx;
  border-radius: 8rpx;
  overflow: hidden;
}

.variation-item image {
  width: 100%;
  height: 100%;
}

.specifications {
  padding: 30rpx;
}

.spec-item {
  display: flex;
  justify-content: space-between;
  margin-bottom: 20rpx;
}

.spec-label {
  color: #666;
}

.delivery {
  padding: 30rpx;
}

.delivery-options {
  border-radius: 12rpx;
  overflow: hidden;
}

.delivery-option {
  display: flex;
  justify-content: space-between;
  padding: 30rpx;
  background: #f8f8f8;
  margin-bottom: 20rpx;
}

.delivery-option.selected {
  background: #e6f3ff;
}

.option-info {
  display: flex;
  flex-direction: column;
}

.option-name {
  font-size: 28rpx;
  font-weight: bold;
}

.option-time {
  font-size: 24rpx;
  color: #666;
  margin-top: 8rpx;
}

.option-price {
  font-weight: bold;
}

.bottom-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  display: flex;
  padding: 20rpx;
  background: #fff;
  box-shadow: 0 -2rpx 10rpx rgba(0,0,0,0.05);
}

.cart-btn, .buy-btn {
  flex: 1;
  height: 80rpx;
  line-height: 80rpx;
  text-align: center;
  border-radius: 40rpx;
  margin: 0 10rpx;
}

.cart-btn {
  background: #f8f8f8;
}

.buy-btn {
  background: #1890ff;
  color: #fff;
}