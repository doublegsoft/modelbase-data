<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4js.ftl" as modelbase4js>
<#assign obj = browsable>
<#assign idAttr = modelbase.get_id_attributes(obj)[0]>
<view class="page">
  <view style="position: fixed; top: -1px; padding: 8px;z-index: 999999; width: 100%; background-color: white;">
    <view class="search-bar">
      <icon type="search" color="#999" class="icon" />
      <input type="text" style="width: 200px;" placeholder-class="placeholder" placeholder="搜索" 
            bind:tap="gotoSearch" value="{{searchCriteria}}" disabled="true"/>
    </view>
  </view>
  <view class="gx-pos-relative" style="top: 56px;">
    <gx-grid-vew id="grid${js.nameType(obj.name)}" enableLoadMore="{{true}}" local="{{odd${js.nameType(inflector.pluralize(obj.name))}}}"
                 bind:doLoad="fetch${js.nameType(inflector.pluralize(obj.name))}">
      <view class="gx-row">
        <view class="gx-24-12">
          <view class="gx-m-8 gx-mr-8" wx:for="odd${js.nameType(inflector.pluralize(obj.name))}" wx:key="${modelbase.get_attribute_sql_name(idAttr)}"
                wx:for-item="item">
            <view class="card product-card" data-${obj.name?replace("_","-")}="{{item}}" bind:tap="goto${java.nameType(obj.name)}Detail">
              <view class="position-relative">
                <image src="http://192.168.0.207:9098/img/demo/gux/t-shirt.png" mode="heightFix" 
                       style="height:180px;"/>
                <view class="sale-badge">在售</view>
              </view>
              <view class="card-body text-center">
                <view class="card-title gx-mb-8">透气汗衫</view>
                <view class="product-price gx-color-primary">
                  <view class="price-icon fas fa-dollar-sign"></view>
                  <view>254.99</view>
                </view>
              </view>
            </view>
          </view>
        </view>
        <view class="gx-24-12">
          <view class="gx-m-8 gx-ml-8" wx:for="even${js.nameType(inflector.pluralize(obj.name))}" wx:key="${modelbase.get_attribute_sql_name(idAttr)}"
                wx:for-item="item">
            <view class="card product-card position-relative">
              <span class="badge badge-verified">热销</span>
              <image src="http://192.168.0.207:9098/img/demo/gux/shoe.png" mode="widthFix" style="width:100%;" />
              <view class="card-body">
                <text class="card-title">这是一双鞋</text>
                <view class="rating gx-mt-8">
                  <text class="fas fa-star"></text>
                  <text class="fas fa-star"></text>
                  <text class="fas fa-star"></text>
                  <text class="fas fa-star"></text>
                  <text class="fas fa-star-half-alt"></text>
                </view>
                <button class="btn btn-purchase gx-mt-8" style="width:120px;"
                        data-${obj.name?replace("_","-")}="{{item}}" bind:tap="goto${java.nameType(obj.name)}Detail">
                  立即购买
                </button>
              </view>
            </view>
          </view>
        </view>
      </view>
    </gx-grid-vew>
  </view>
</view>