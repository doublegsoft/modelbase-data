<template>
  <view class="container">
    <view class="header">
      <view class="back-button" @tap="goBack">
        <text class="icon">←</text>
      </view>
      <text class="title">Add New Item</text>
      <view class="save-button" @tap="saveItem">
        <text>Save</text>
      </view>
    </view>
    
    <view class="form-container">
      <view class="form-section">
        <text class="section-title">Type</text>
        <view class="type-selector">
          <view 
            class="type-option" 
            :class="{ active: itemType === 'medication' }"
            @tap="itemType = 'medication'"
          >
            <text class="icon">💊</text>
            <text>Medication</text>
          </view>
          <view 
            class="type-option" 
            :class="{ active: itemType === 'meal' }"
            @tap="itemType = 'meal'"
          >
            <text class="icon">🍽️</text>
            <text>Meal</text>
          </view>
          <view 
            class="type-option" 
            :class="{ active: itemType === 'activity' }"
            @tap="itemType = 'activity'"
          >
            <text class="icon">🏃</text>
            <text>Activity</text>
          </view>
        </view>
      </view>
      
      <view class="form-section">
        <text class="section-title">Date & Time</text>
        <view class="date-time-picker">
          <picker 
            mode="date" 
            :value="date" 
            @change="onDateChange"
            class="picker"
          >
            <view class="picker-view">
              <text>{{ formattedDate }}</text>
            </view>
          </picker>
          
          <picker 
            mode="time" 
            :value="time" 
            @change="onTimeChange"
            class="picker"
          >
            <view class="picker-view">
              <text>{{ formattedTime }}</text>
            </view>
          </picker>
        </view>
      </view>
      
      <!-- Medication-specific fields -->
      <block v-if="itemType === 'medication'">
        <view class="form-section">
          <text class="section-title">Medication Details</text>
          <input 
            class="input-field" 
            type="text" 
            v-model="medicationName" 
            placeholder="Medication Name"
          />
          <view class="dose-container">
            <input 
              class="input-field dose-input" 
              type="number" 
              v-model="dosage" 
              placeholder="Dosage"
            />
            <picker 
              :value="doseUnitIndex" 
              :range="doseUnits"
              @change="onDoseUnitChange"
              class="picker unit-picker"
            >
              <view class="picker-view">
                <text>{{ doseUnits[doseUnitIndex] }}</text>
              </view>
            </picker>
          </view>
          <input 
            class="input-field" 
            type="number" 
            v-model="quantity" 
            placeholder="Quantity (pills, tablets, etc.)"
          />
        </view>
      </block>
      
      <!-- Meal-specific fields -->
      <block v-if="itemType === 'meal'">
        <view class="form-section">
          <text class="section-title">Meal Details</text>
          <picker 
            :value="mealTypeIndex" 
            :range="mealTypes"
            @change="onMealTypeChange"
            class="picker"
          >
            <view class="picker-view">
              <text>{{ mealTypes[mealTypeIndex] }}</text>
            </view>
          </picker>
          <input 
            class="input-field" 
            type="number" 
            v-model="calories" 
            placeholder="Calories"
          />
          <textarea 
            class="textarea-field" 
            v-model="mealDescription" 
            placeholder="Description (optional)"
          />
        </view>
      </block>
      
      <!-- Activity-specific fields -->
      <block v-if="itemType === 'activity'">
        <view class="form-section">
          <text class="section-title">Activity Details</text>
          <input 
            class="input-field" 
            type="text" 
            v-model="activityName" 
            placeholder="Activity Name"
          />
          <view class="duration-container">
            <input 
              class="input-field" 
              type="number" 
              v-model="duration" 
              placeholder="Duration"
            />
            <picker 
              :value="durationUnitIndex" 
              :range="durationUnits"
              @change="onDurationUnitChange"
              class="picker unit-picker"
            >
              <view class="picker-view">
                <text>{{ durationUnits[durationUnitIndex] }}</text>
              </view>
            </picker>
          </view>
          <input 
            class="input-field" 
            type="number" 
            v-model="caloriesBurned" 
            placeholder="Calories Burned (optional)"
          />
        </view>
      </block>
      
      <view class="form-section">
        <text class="section-title">Reminder</text>
        <view class="reminder-toggle">
          <text>Set a reminder</text>
          <switch 
            :checked="reminderEnabled" 
            @change="onReminderToggle" 
            color="#2fb0ff"
          />
        </view>
      </view>
    </view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      itemType: 'medication',
      date: '2023-03-15',
      time: '08:00',
      
      // Medication fields
      medicationName: '',
      dosage: '',
      doseUnits: ['mg', 'mcg', 'g', 'mL'],
      doseUnitIndex: 0,
      quantity: '',
      
      // Meal fields
      mealTypes: ['Breakfast', 'Lunch', 'Dinner', 'Snack'],
      mealTypeIndex: 0,
      calories: '',
      mealDescription: '',
      
      // Activity fields
      activityName: '',
      duration: '',
      durationUnits: ['minutes', 'hours'],
      durationUnitIndex: 0,
      caloriesBurned: '',
      
      // Reminder
      reminderEnabled: false
    };
  },
  computed: {
    formattedDate() {
      // Format the date for display
      const dateObj = new Date(this.date);
      const options = { weekday: 'short', month: 'short', day: 'numeric' };
      return dateObj.toLocaleDateString('en-US', options);
    },
    formattedTime() {
      // Format the time for display
      const [hours, minutes] = this.time.split(':');
      const hour = parseInt(hours);
      const ampm = hour >= 12 ? 'PM' : 'AM';
      const hour12 = hour % 12 || 12;
      return `${r"${"}hour12}:${r"${"}minutes} ${r"${"}ampm}`;
    }
  },
  methods: {
    goBack() {
      uni.navigateBack();
    },
    saveItem() {
      // Validate inputs
      if (!this.validateForm()) {
        return;
      }
      
      // Create item object based on type
      let item = {
        type: this.itemType,
        date: this.date,
        time: this.time,
        reminderEnabled: this.reminderEnabled
      };
      
      if (this.itemType === 'medication') {
        item = {
          ...item,
          name: this.medicationName,
          dosage: this.dosage,
          doseUnit: this.doseUnits[this.doseUnitIndex],
          quantity: this.quantity
        };
      } else if (this.itemType === 'meal') {
        item = {
          ...item,
          name: this.mealTypes[this.mealTypeIndex],
          calories: this.calories,
          description: this.mealDescription
        };
      } else if (this.itemType === 'activity') {
        item = {
          ...item,
          name: this.activityName,
          duration: this.duration,
          durationUnit: this.durationUnits[this.durationUnitIndex],
          caloriesBurned: this.caloriesBurned
        };
      }
      
      console.log('Saving item:', item);
      
      // Here you would save the item to your storage/database
      uni.showToast({
        title: 'Item saved',
        icon: 'success'
      });
      
      // Navigate back
      setTimeout(() => {
        uni.navigateBack();
      }, 1500);
    },
    validateForm() {
      if (this.itemType === 'medication') {
        if (!this.medicationName || !this.dosage || !this.quantity) {
          uni.showToast({
            title: 'Please fill all required fields',
            icon: 'none'
          });
          return false;
        }
      } else if (this.itemType === 'meal') {
        if (!this.calories) {
          uni.showToast({
            title: 'Please enter calories',
            icon: 'none'
          });
          return false;
        }
      } else if (this.itemType === 'activity') {
        if (!this.activityName || !this.duration) {
          uni.showToast({
            title: 'Please fill all required fields',
            icon: 'none'
          });
          return false;
        }
      }
      
      return true;
    },
    onDateChange(e) {
      this.date = e.detail.value;
    },
    onTimeChange(e) {
      this.time = e.detail.value;
    },
    onDoseUnitChange(e) {
      this.doseUnitIndex = e.detail.value;
    },
    onMealTypeChange(e) {
      this.mealTypeIndex = e.detail.value;
    },
    onDurationUnitChange(e) {
      this.durationUnitIndex = e.detail.value;
    },
    onReminderToggle(e) {
      this.reminderEnabled = e.detail.value;
    }
  }
};
</script>

<style>
.container {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background-color: #f8f8fa;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px;
  background-color: #fff;
  border-bottom: 1px solid #eee;
}

.back-button {
  width: 40px;
  height: 40px;
  display: flex;
  justify-content: center;
  align-items: center;
}

.title {
  font-size: 18px;
  font-weight: bold;
}

.save-button {
  padding: 8px 15px;
  background-color: #2fb0ff;
  border-radius: 20px;
  color: #fff;
}

.form-container {
  flex: 1;
  padding: 20px;
}

.form-section {
  margin-bottom: 20px;
  background-color: #fff;
  border-radius: 10px;
  padding: 15px;
}

.section-title {
  font-size: 16px;
  font-weight: bold;
  margin-bottom: 10px;
}

.type-selector {
  display: flex;
  justify-content: space-between;
}

.type-option {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 15px;
  border-radius: 10px;
  background-color: #f8f8fa;
  width: 30%;
}

.type-option.active {
  background-color: #e6f7ff;
  border: 1px solid #2fb0ff;
}

.type-option .icon {
  font-size: 24px;
  margin-bottom: 5px;
}

.date-time-picker {
  display: flex;
  justify-content: space-between;
}

.picker {
  width: 48%;
}

.picker-view {
  height: 40px;
  line-height: 40px;
  padding: 0 10px;
  background-color: #f8f8fa;
  border-radius: 8px;
}

.input-field {
  height: 40px;
  background-color: #f8f8fa;
  border-radius: 8px;
  padding: 0 10px;
  margin-bottom: 10px;
}

.textarea-field {
  background-color: #f8f8fa;
  border-radius: 8px;
  padding: 10px;
  height: 100px;
  width: 100%;
}

.dose-container, .duration-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.dose-input {
  width: 60%;
}

.unit-picker {
  width: 35%;
}

.reminder-toggle {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
</style>