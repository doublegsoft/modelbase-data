<#macro print_html_of_list_view obj indent>
<recycle-view batch="{{batchSetRecycleData}}" id="recycleId">
  <recycle-item wx:for="{{gestationParturitions}}" wx:key="patientId" style="width: 100%;">
    <navigator url='../item/item?id={{item.subject.id}}'>
      <view class='item'>
        <image class='poster' src='https://via.placeholder.com/128'></image>
        <view class='meta'>
          <text class='title'>{{item.patientName}}</text>
          <text class='sub-title'>{{item.hospitalName}}</text>
          <view class='rating'>
            <text>{{item.subject.rating.average}}</text>
          </view>
        </view>
      </view>
    </navigator>
  </recycle-item>
</recycle-view>
</#macro>
