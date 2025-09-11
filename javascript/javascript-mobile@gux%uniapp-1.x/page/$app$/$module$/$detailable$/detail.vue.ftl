<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4js.ftl" as modelbase4js>
<#assign obj = detailable>
<#assign idAttrs = modelbase.get_id_attributes(obj)>
<#assign levelledAttrs = modelbase.level_object_attributes(obj)>
<template>
  <view class="container" style="<#if obj.isLabelled("purchasable")>padding-bottom:160rpx;</#if>">
    <view class="nav-buttons" style="position:fixed;z-index:1;">
      <view class="nav-button back-button" @tap="goBack">
        <text class="gx-i gx-i-backward"></text>
      </view>
      <view style="display: flex;">
  <#if obj.isLabelled("favoriteable")>                
        <view class="nav-button" style="margin-right: 10px;" @tap="doFavorite">
          <text class="gx-i gx-i-star"></text>
        </view>
  </#if> 
  <#if obj.isLabelled("shareable")>                
        <view class="nav-button" @tap="doShare">
          <text class="gx-i gx-i-share"></text>
        </view>
  </#if>    
      </view>
    </view>
<#if (levelledAttrs["image"]?size > 0)>     
    <view class="header-image">
      <image :src="${js.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(levelledAttrs["image"][0])}" style="width:100%;height:100%;border-radius:0 0 10px 10px;"></image>    
    </view>
 </#if>     
    <view class="food-details">
      <view class="title-section">
<#if (levelledAttrs["primary"]?size > 0)>        
        <text class="food-title">{{ ${js.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(levelledAttrs["primary"][0])} }}</text>
<#else>    
        <text class="food-title">主要标题</text>    
</#if>        
        <view class="location">
          <view class="location-dot"></view>
<#if (levelledAttrs["secondary"]?size > 0)>        
          <text class="location-text">{{ ${js.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(levelledAttrs["secondary"][0])} }}</text>
<#else>    
          <text class="location-text">次要标题</text>
</#if>           
        </view>
      </view>
      
      <view class="ratings-info">
<#if obj.isLabelled("scoreable")>      
        <view class="rating">
          <text class="rating-icon">★</text>
          <text class="rating-value">4.7</text>
        </view>
</#if>        
        <view class="delivery-info">
          <text class="delivery-icon">🚚</text>
          <text class="delivery-text">Free</text>
        </view>
        <view class="time-info">
          <text class="time-icon">⏱</text>
          <text class="time-text">20 min</text>
        </view>
      </view>
      
      <!-- Description -->
      <view class="description">
        <text class="description-text">Maecenas sed diam eget risus varius blandit sit amet non magna. Integer posuere erat a ante venenatis dapibus posuere velit aliquet.</text>
      </view>
      
      <!-- Size Selection -->
      <view class="size-section">
        <text class="section-label">SIZE:</text>
        <view class="size-options">
          <view class="size-option">
            <text class="size-text">10"</text>
          </view>
          <view class="size-option selected">
            <text class="size-text">14"</text>
          </view>
          <view class="size-option">
            <text class="size-text">16"</text>
          </view>
        </view>
      </view>
      
      <!-- Ingredients -->
      <view class="ingredients-section">
        <text class="section-label">INGREDIENTS</text>
        <view class="ingredients-grid">
          <!-- Row 1 -->
          <view class="ingredient-item">
            <view class="ingredient-icon">
              <text>🧂</text>
            </view>
            <text class="ingredient-name">Salt</text>
          </view>
          
          <view class="ingredient-item">
            <view class="ingredient-icon">
              <text>🍗</text>
            </view>
            <text class="ingredient-name">Chicken</text>
          </view>
          
          <view class="ingredient-item">
            <view class="ingredient-icon">
              <text>🧅</text>
            </view>
            <text class="ingredient-name">Onion</text>
            <text class="allergy-tag">(Allergy)</text>
          </view>
          
          <view class="ingredient-item">
            <view class="ingredient-icon">
              <text>🧄</text>
            </view>
            <text class="ingredient-name">Garlic</text>
          </view>
          
          <view class="ingredient-item">
            <view class="ingredient-icon">
              <text>🌶️</text>
            </view>
            <text class="ingredient-name">Peppers</text>
            <text class="allergy-tag">(Allergy)</text>
          </view>
          <view class="ingredient-item">
            <view class="ingredient-icon">
              <text>🧄</text>
            </view>
            <text class="ingredient-name">Ginger</text>
          </view>
          <view class="ingredient-item">
            <view class="ingredient-icon">
              <text>🥦</text>
            </view>
            <text class="ingredient-name">Broccoli</text>
          </view>
          
          <view class="ingredient-item">
            <view class="ingredient-icon">
              <text>🍊</text>
            </view>
            <text class="ingredient-name">Orange</text>
          </view>
          
          <view class="ingredient-item">
            <view class="ingredient-icon">
              <text>🌰</text>
            </view>
            <text class="ingredient-name">Walnut</text>
          </view>
        </view>
      </view>
    </view>
<#if obj.isLabelled("commentable")>
    <view class="gx-px-16 gx-my-16 gx-d-flex gx-lh-32">
      <view class="gx-fs-16 gx-fb">最近评论</view>
      <view class="gx-fs-12 gx-text-primary gx-ml-auto" @tap="route.goto${js.nameType(obj.name)}List">更多评论</view>
    </view>
    <comment></comment>
</#if>
<#if obj.isLabelled("purchasable")>
    <view class="bottom gx-d-flex">
      <view class="button">加入购物车</view>
      <view class="button" @tap="gotoPay">直接购买</view>
    </view>
</#if>
  </view>  
<#if obj.isLabelled("shareable")>
  <share ref="share"></share>
</#if>    
</template>

<script>
const app = getApp();
import { sdk } from '@/sdk/sdk';
import * as route from '@/route';
import '@/app.css';
<#if obj.isLabelled("commentable")>
import comment from '@/design/comment';
</#if>
<#if obj.isLabelled("shareable")>
import share from '@/design/share';
</#if>
export default {
  components: {
<#if obj.isLabelled("commentable")>
    comment,
</#if>  
<#if obj.isLabelled("shareable")>
    share,
</#if>  
  },
  data() {
    return {
      selectedSize: '14"',
      isFavorite: false,
      ${js.nameVariable(obj.name)}: {},
      foodItem: {
        name: 'Burger Bistro',
        location: 'Rose Garden',
        rating: 4.7,
        delivery: 'Free',
        time: '20 min',
        description: 'Maecenas sed diam eget risus varius blandit sit amet non magna. Integer posuere erat a ante venenatis dapibus posuere velit aliquet.',
        sizes: ['10"', '14"', '16"'],
        ingredients: [
          { name: 'Salt', icon: '🧂', allergy: false },
          { name: 'Chicken', icon: '🍗', allergy: false },
          { name: 'Onion', icon: '🧅', allergy: true },
          { name: 'Garlic', icon: '🧄', allergy: false },
          { name: 'Peppers', icon: '🌶️', allergy: true },
          { name: 'Ginger', icon: '🧄', allergy: false },
          { name: 'Broccoli', icon: '🥦', allergy: false },
          { name: 'Orange', icon: '🍊', allergy: false },
          { name: 'Walnut', icon: '🌰', allergy: false }
        ]
      }
    }
  },
  
  mounted() {
  },
  
  onLoad(params) {
    this.fetch${js.nameType(obj.name)}({
<#list idAttrs as idAttr>
      ${modelbase.get_attribute_sql_name(idAttr)}: params.${modelbase.get_attribute_sql_name(idAttr)},
</#list>    
    });
  },
  methods: {
  
    async fetch${js.nameType(obj.name)}(params) {
      this.${js.nameVariable(obj.name)} = await sdk.read${js.nameType(obj.name)}(params);
    },
    
    goBack() {
      uni.navigateBack();
    },
<#if obj.isLabelled("favoriteable")>    
    
    /*!
    ** 收藏或者取消收藏。
    */
    doFavorite() {
    },
</#if>  
<#if obj.isLabelled("shareable")>    
    
    /*!
    ** 分享。
    */
    doShare() {
      this.$refs.share.show();
    },
</#if>   
<#if obj.isLabelled("purchasable")>    
    
    /*!
    ** 跳转到【支付】。
    */
    gotoPay() {
      route.goto${js.nameType(obj.name)}Pay();
    },
</#if>  
  }
}
</script>

<style>
.container {
  background-color: #ffffff;
  min-height: 100vh;
}

.bottom {
  position:fixed;
  bottom:0;
  width:100%;
  height:160rpx;
  background: #eaeaea;
  align-items:center;
  justify-content: space-around;
}

.button {
  background-color: var(--color-primary);
  color: white; 
  border: none; 
  padding: 12px 20px; 
  font-size: 16px; 
  font-weight: bold; 
  border-radius: 9999px;
  transition: background-color 0.3s ease; 
  text-align: center;
  width: 100px;
}

/* Header Image */
.header-image {
  position: relative;
  width: 100%;
  height: 600rpx;
}

.food-image {
  width: 100%;
  height: 100%;
  border-radius: 20rpx 20rpx 0 0;
  background-color: #a6b6c3;
}

.nav-buttons {
  position: absolute;
  top: 20rpx;
  left: 0;
  right: 0;
  display: flex;
  justify-content: space-between;
  padding: 0 20rpx;
}

.nav-button {
  width: 80rpx;
  height: 80rpx;
  background-color: #ffffff;
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
}

.nav-icon {
  font-size: 40rpx;
}

.favorite-icon {
  color: orange;
}

/* Food Details */
.food-details {
  padding: 30rpx;
}

.title-section {
  margin-bottom: 20rpx;
}

.food-title {
  font-size: 48rpx;
  font-weight: bold;
  margin-bottom: 10rpx;
}

.location {
  display: flex;
  align-items: center;
}

.location-dot {
  width: 20rpx;
  height: 20rpx;
  background-color: red;
  border-radius: 50%;
  margin-right: 10rpx;
}

.location-text {
  font-size: 28rpx;
  color: #666666;
}

/* Ratings and Info */
.ratings-info {
  display: flex;
  margin-bottom: 30rpx;
}

.rating, .delivery-info, .time-info {
  display: flex;
  align-items: center;
  margin-right: 40rpx;
}

.rating-icon {
  color: orange;
  margin-right: 10rpx;
}

.delivery-icon, .time-icon {
  color: #333;
  margin-right: 10rpx;
}

/* Description */
.description {
  margin-bottom: 30rpx;
}

.description-text {
  font-size: 28rpx;
  color: #999999;
  line-height: 1.5;
}

/* Size Selection */
.size-section {
  margin-bottom: 30rpx;
}

.section-label {
  font-size: 28rpx;
  font-weight: bold;
  color: #666666;
  margin-bottom: 20rpx;
  display: block;
}

.size-options {
  display: flex;
}

.size-option {
  width: 100rpx;
  height: 100rpx;
  background-color: #f5f5f5;
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
  margin-right: 20rpx;
}

.size-option.selected {
  background-color: #f8a154;
}

.size-text {
  font-size: 28rpx;
  font-weight: bold;
}

/* Ingredients */
.ingredients-grid {
  display: flex;
  flex-wrap: wrap;
}

.ingredient-item {
  width: 20%;
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 30rpx;
}

.ingredient-icon {
  width: 100rpx;
  height: 100rpx;
  background-color: #fff2ee;
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
  margin-bottom: 10rpx;
}

.ingredient-name {
  font-size: 24rpx;
  text-align: center;
}

.allergy-tag {
  font-size: 20rpx;
  color: #ff6b6b;
}
</style>