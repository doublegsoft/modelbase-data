<#import "/$/modelbase.ftl" as modelbase>
<template>
  <el-container style="height:100vh;overflow:hidden;display:flex">
    <el-aside width="auto" style="width:256px;height:100%;">
      <div class="p-6" style="height:68px;line-height:68px;background:white;">
        <div class="flex items-center space-x-3">
          <div class="w-8 h-8 bg-blue-500 rounded-lg flex items-center justify-center">
            <i class="fas fa-futbol text-white text-sm"></i>
          </div>
          <h1 class="text-xl font-bold text-gray-800">${app.name?upper_case}</h1>
        </div>
      </div>
      <SideMenu />
    </el-aside>
    <el-main style="height:100%;overflow:hidden;">
      <el-header style="width:100%;display:flex;height:68px;">
        <Breadcrumb />
        <div style="display:flex;align-items:center;margin-left:auto;">
          <el-avatar :size="32" src="circleUrl" class="gx-mr-8"/>
          <el-dropdown trigger="click">
            <span class="el-dropdown-link">
              <el-icon class="el-icon--right"><arrow-down /></el-icon>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item>个人中心</el-dropdown-item>
                <el-dropdown-item>系统消息</el-dropdown-item>
                <el-dropdown-item>智能助手</el-dropdown-item>
                <el-dropdown-item divided class="gx-text-error">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </el-header>
      <el-divider style="margin:0;" />
      <view style="width:100%;height:calc(100% - 68px);padding-top:16px;display:flex;flex-direction:column;overflow-y:auto;">
        <keep-alive>
          <router-view v-if="$route.meta.keepAlive" />
        </keep-alive>
        <router-view v-if="!$route.meta.keepAlive" />
      </view>
    </el-main>
  </el-container>
</template>

<script>
import SideMenu from './widget/side-menu.vue';
import Breadcrumb from './widget/breadcrumb.vue';
export default {
  components: {
    SideMenu,
    Breadcrumb,
  },
}
</script>
<style>
.el-main {
  padding: 0!important;
}
</style>