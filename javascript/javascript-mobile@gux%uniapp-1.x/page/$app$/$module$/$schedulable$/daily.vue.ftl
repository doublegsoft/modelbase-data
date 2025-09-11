<template>
  <view class="container">
    <!-- Status Bar -->
    <view class="status-bar">
      <text class="time">9:41</text>
      <view class="status-icons">
        <text class="icon-signal">●●●●</text>
        <text class="icon-wifi">●●●</text>
        <text class="icon-battery">●●●●</text>
      </view>
    </view>
    
    <!-- Month Selector -->
    <view class="header">
      <view class="month-selector">
        <text class="month-text">March</text>
        <text class="icon-dropdown">▼</text>
      </view>
      <view class="calendar-icon">
        <text class="icon">📅</text>
      </view>
    </view>
    
    <!-- Days Selector -->
    <scroll-view scroll-x="true" class="days-scroll" show-scrollbar="false">
      <view class="days-container">
        <view class="day-item">
          <text class="day-name">Sun</text>
          <text class="day-number">14</text>
        </view>
        <view class="day-item selected">
          <text class="day-name">Mon</text>
          <text class="day-number">15</text>
        </view>
        <view class="day-item">
          <text class="day-name">Tue</text>
          <text class="day-number">16</text>
        </view>
        <view class="day-item">
          <text class="day-name">Wed</text>
          <text class="day-number">17</text>
        </view>
        <view class="day-item">
          <text class="day-name">Thu</text>
          <text class="day-number">18</text>
        </view>
        <view class="day-item">
          <text class="day-name">Fri</text>
          <text class="day-number">19</text>
        </view>
        <view class="day-item">
          <text class="day-name">Sat</text>
          <text class="day-number">20</text>
        </view>
      </view>
    </scroll-view>
    
    <!-- Schedule Items -->
    <scroll-view scroll-y="true" class="schedule-container">
      <view class="schedule-item">
        <text class="time-label">8:00 AM</text>
        <view class="item-card medication">
          <view class="icon-container medication-icon">
            <text class="icon">💊</text>
          </view>
          <view class="item-details">
            <text class="item-title">Ibuprofen (500mg)</text>
            <text class="item-subtitle">1 capsule</text>
          </view>
        </view>
      </view>
      
      <view class="schedule-item">
        <text class="time-label">8:30 AM</text>
        <view class="item-card meal">
          <view class="icon-container meal-icon">
            <text class="icon">🍽️</text>
          </view>
          <view class="item-details">
            <text class="item-title">Breakfast</text>
            <text class="item-subtitle">350 kCal</text>
          </view>
        </view>
      </view>
      
      <view class="schedule-item">
        <text class="time-label">12:00 AM</text>
        <view class="item-card meal active">
          <view class="icon-container meal-icon">
            <text class="icon">🍽️</text>
          </view>
          <view class="item-details">
            <text class="item-title">Lunch</text>
            <text class="item-subtitle">500 kCal</text>
          </view>
        </view>
      </view>
      
      <view class="schedule-item">
        <text class="time-label">8:00 AM</text>
        <view class="item-card medication">
          <view class="icon-container medication-icon">
            <text class="icon">💊</text>
          </view>
          <view class="item-details">
            <text class="item-title">Metformin (400mg)</text>
            <text class="item-subtitle">1 capsule</text>
          </view>
        </view>
      </view>
      
      <view class="schedule-item">
        <text class="time-label">12:00 AM</text>
        <view class="item-card meal">
          <view class="icon-container meal-icon">
            <text class="icon">🍽️</text>
          </view>
          <view class="item-details">
            <text class="item-title">Dinner</text>
            <text class="item-subtitle">650 kCal</text>
          </view>
        </view>
      </view>
      
      <view class="schedule-item">
        <text class="time-label">8:00 AM</text>
        <view class="item-card medication">
          <view class="icon-container medication-icon">
            <text class="icon">💊</text>
          </view>
          <view class="item-details">
            <text class="item-title">Lisinopril (10mg)</text>
            <text class="item-subtitle">1 capsule</text>
          </view>
        </view>
      </view>
      
      <!-- Add some space at the bottom for better scrolling -->
      <view style="height: 100px;"></view>
    </scroll-view>
    
    <!-- Floating Action Button -->
    <view class="fab">
      <text class="fab-icon">+</text>
    </view>
    
    <!-- Bottom Navigation -->
    <view class="tab-bar">
      <view class="tab-item">
        <text class="tab-icon">🏠</text>
      </view>
      <view class="tab-item">
        <text class="tab-icon">📊</text>
      </view>
      <view class="tab-item active">
        <text class="tab-icon">📆</text>
        <view class="tab-indicator"></view>
      </view>
      <view class="tab-item">
        <text class="tab-icon">⚙️</text>
      </view>
    </view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      selectedDay: 15,
      selectedMonth: 'March',
      scheduleItems: [
        {
          time: '8:00 AM',
          type: 'medication',
          title: 'Ibuprofen (500mg)',
          subtitle: '1 capsule',
          active: false
        },
        {
          time: '8:30 AM',
          type: 'meal',
          title: 'Breakfast',
          subtitle: '350 kCal',
          active: false
        },
        {
          time: '12:00 AM',
          type: 'meal',
          title: 'Lunch',
          subtitle: '500 kCal',
          active: true
        },
        {
          time: '8:00 AM',
          type: 'medication',
          title: 'Metformin (400mg)',
          subtitle: '1 capsule',
          active: false
        },
        {
          time: '12:00 AM',
          type: 'meal',
          title: 'Dinner',
          subtitle: '650 kCal',
          active: false
        },
        {
          time: '8:00 AM',
          type: 'medication',
          title: 'Lisinopril (10mg)',
          subtitle: '1 capsule',
          active: false
        }
      ]
    };
  },
  methods: {
    selectDay(day) {
      this.selectedDay = day;
      // Load schedule for the selected day
      this.loadSchedule();
    },
    loadSchedule() {
      // Would fetch data based on the selected date
      console.log(`Loading schedule for ${r"${"}this.selectedMonth} ${r"${"}this.selectedDay}`);
    },
    addNewItem() {
      uni.navigateTo({
        url: '/pages/add-item/index'
      });
    }
  },
  onLoad() {
    this.loadSchedule();
  }
};
</script>

<style>
.container {
  display: flex;
  flex-direction: column;
  height: 100vh;
  background-color: #f8f8fa;
}

/* Status Bar */
.status-bar {
  display: flex;
  justify-content: space-between;
  padding: 10px 15px;
  font-size: 14px;
}

.time {
  font-weight: bold;
}

.status-icons {
  display: flex;
  gap: 8px;
}

/* Header */
.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 20px;
}

.month-selector {
  display: flex;
  align-items: center;
  gap: 5px;
  background-color: #f0f0f0;
  padding: 8px 16px;
  border-radius: 20px;
}

.month-text {
  font-weight: bold;
  font-size: 16px;
}

.icon-dropdown {
  font-size: 12px;
  color: #666;
}

.calendar-icon {
  width: 40px;
  height: 40px;
  display: flex;
  justify-content: center;
  align-items: center;
  font-size: 20px;
}

/* Days Selector */
.days-scroll {
  white-space: nowrap;
  height: 80px;
}

.days-container {
  display: flex;
  padding: 10px;
}

.day-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: 60px;
  height: 60px;
  margin: 0 5px;
  border-radius: 30px;
}

.day-item.selected {
  background-color: #d3f0ff;
  border: 2px solid #2fb0ff;
}

.day-name {
  font-size: 12px;
  color: #666;
}

.day-number {
  font-size: 18px;
  font-weight: bold;
  margin-top: 4px;
}

/* Schedule */
.schedule-container {
  flex: 1;
  padding: 0 20px;
}

.schedule-item {
  display: flex;
  margin-bottom: 15px;
}

.time-label {
  width: 80px;
  font-size: 14px;
  color: #666;
  padding-top: 15px;
}

.item-card {
  flex: 1;
  display: flex;
  background-color: #fff;
  border-radius: 15px;
  padding: 10px;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
}

.item-card.active {
  background-color: #e6f7ff;
}

.icon-container {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  display: flex;
  justify-content: center;
  align-items: center;
  margin-right: 10px;
}

.medication-icon {
  background-color: #e1f5fe;
}

.meal-icon {
  background-color: #e8f5e9;
}

.item-details {
  flex: 1;
}

.item-title {
  font-weight: bold;
  font-size: 16px;
}

.item-subtitle {
  font-size: 14px;
  color: #666;
  margin-top: 4px;
}

/* Floating Action Button */
.fab {
  position: fixed;
  right: 20px;
  bottom: 80px;
  width: 60px;
  height: 60px;
  border-radius: 30px;
  background-color: #2fb0ff;
  display: flex;
  justify-content: center;
  align-items: center;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
  z-index: 100;
}

.fab-icon {
  color: #fff;
  font-size: 30px;
  font-weight: bold;
}

/* Tab Bar */
.tab-bar {
  height: 60px;
  display: flex;
  background-color: #fff;
  border-top: 1px solid #eee;
}

.tab-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  position: relative;
}

.tab-icon {
  font-size: 24px;
}

.tab-indicator {
  position: absolute;
  bottom: 0;
  width: 40px;
  height: 4px;
  background-color: #2fb0ff;
  border-radius: 2px;
}
</style>