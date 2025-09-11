<template>
  <view class="container">
    <!-- Status bar placeholder -->
    <view class="status-bar">
      <text class="time">9:41</text>
      <view class="status-icons">
        <text class="signal-icon">􀙇</text>
        <text class="wifi-icon">􀙈</text>
        <text class="battery-icon">􀋨</text>
      </view>
    </view>
    
    <!-- Back button -->
    <view class="back-button" @click="goBack">
      <text class="back-icon">←</text>
    </view>
    
    <!-- Match score header -->
    <view class="match-header">
      <view class="team home-team">
        <image class="team-logo" src="/static/man-city-logo.png" mode="aspectFit"></image>
        <text class="team-name">Man City</text>
        <text class="team-status">Home</text>
      </view>
      
      <view class="score-container">
        <view class="score">
          <text class="score-number">1</text>
          <text class="score-divider">-</text>
          <text class="score-number">1</text>
        </view>
        <text class="match-time">81'</text>
      </view>
      
      <view class="team away-team">
        <image class="team-logo" src="/static/arsenal-logo.png" mode="aspectFit"></image>
        <text class="team-name">Arsenal</text>
        <text class="team-status">Away</text>
      </view>
    </view>
    
    <!-- Match events -->
    <view class="match-events">
      <view class="event">
        <text class="event-team-left">R. Mahrez 57' (Pen)</text>
        <view class="event-icon ball">⚽</view>
        <text class="event-team-right">B. Saka 31'</text>
      </view>
      
      <view class="event">
        <text class="event-team-left"></text>
        <view class="event-icon red-card"></view>
        <text class="event-team-right">Gabriel Magalhaes 59'</text>
      </view>
    </view>
    
    <!-- Navigation tabs -->
    <view class="tabs">
      <view class="tab active">
        <text class="tab-text active-text">Match</text>
        <view class="active-indicator"></view>
      </view>
      <view class="tab">
        <text class="tab-text">H2H</text>
      </view>
      <view class="tab">
        <text class="tab-text">Standings</text>
      </view>
      <view class="tab">
        <text class="tab-text">News</text>
      </view>
    </view>
    
    <!-- Content tabs -->
    <view class="content-tabs">
      <view class="content-tab">
        <text class="content-tab-text">Summary</text>
      </view>
      <view class="content-tab">
        <text class="content-tab-text">Statistics</text>
      </view>
      <view class="content-tab active-content-tab">
        <text class="content-tab-text active-content-text">Lineup</text>
      </view>
    </view>
    
    <!-- Lineup display -->
    <view class="lineup-container">
      <view class="team-formation">
        <view class="formation-header">
          <image class="small-logo" src="/static/arsenal-logo.png" mode="aspectFit"></image>
          <text class="formation-team">Arsenal</text>
          <text class="formation-structure">4-2-3-1</text>
        </view>
        
        <!-- Football pitch with player positions -->
        <view class="pitch">
          <!-- Goalkeeper -->
          <view class="player-position gk">
            <view class="player-circle">
              <text class="player-number">32</text>
            </view>
            <text class="player-name">A. Ramsdale</text>
          </view>
          
          <!-- Defenders -->
          <view class="player-row defenders">
            <view class="player-position">
              <view class="player-circle">
                <text class="player-number">18</text>
              </view>
              <text class="player-name">T. Tomiyasu</text>
            </view>
            
            <view class="player-position">
              <view class="player-circle">
                <text class="player-number">4</text>
              </view>
              <text class="player-name">B. White</text>
            </view>
            
            <view class="player-position">
              <view class="player-circle">
                <text class="player-number">6</text>
              </view>
              <view class="card red"></view>
              <text class="player-name">Gabriel</text>
            </view>
            
            <view class="player-position">
              <view class="player-circle">
                <text class="player-number">3</text>
              </view>
              <text class="player-name">K. Tierney</text>
            </view>
          </view>
          
          <!-- Defensive Midfielders -->
          <view class="player-row defensive-mid">
            <view class="player-position">
              <view class="player-circle">
                <text class="player-number">5</text>
              </view>
              <text class="player-name">T. Partey</text>
            </view>
            
            <view class="player-position">
              <view class="player-circle">
                <text class="player-number">34</text>
              </view>
              <view class="card yellow"></view>
              <text class="player-name">G. Xhaka</text>
            </view>
          </view>
          
          <!-- Attacking Midfielders -->
          <view class="player-row attacking-mid">
            <view class="player-position">
              <view class="player-circle">
                <text class="player-number">7</text>
              </view>
              <view class="goal-icon">⚽</view>
              <view class="card yellow"></view>
              <text class="player-name">B. Saka</text>
            </view>
            
            <view class="player-position">
              <view class="player-circle">
                <text class="player-number">8</text>
              </view>
              <view class="captain-icon">C</view>
              <text class="player-name">M. Ødegaard</text>
            </view>
            
            <view class="player-position">
              <view class="player-circle">
                <text class="player-number">35</text>
              </view>
              <text class="player-name">G. Martinelli</text>
            </view>
          </view>
          
          <!-- Striker -->
          <view class="player-position striker">
            <view class="player-circle">
              <text class="player-number">9</text>
            </view>
            <text class="player-name">A. Lacazette</text>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      activeMainTab: 'Match',
      activeContentTab: 'Lineup',
      matchInfo: {
        homeTeam: {
          name: 'Man City',
          logo: '/static/man-city-logo.png',
          score: 1,
          events: [
            { player: 'R. Mahrez', minute: 57, type: 'goal', info: 'Pen' }
          ]
        },
        awayTeam: {
          name: 'Arsenal',
          logo: '/static/arsenal-logo.png',
          score: 1,
          events: [
            { player: 'B. Saka', minute: 31, type: 'goal' },
            { player: 'Gabriel Magalhaes', minute: 59, type: 'red-card' }
          ]
        },
        minute: 81,
        status: 'In Progress'
      }
    }
  },
  methods: {
    goBack() {
      uni.navigateBack({
        delta: 1
      });
    },
    changeMainTab(tab) {
      this.activeMainTab = tab;
    },
    changeContentTab(tab) {
      this.activeContentTab = tab;
    }
  }
}
</script>

<style>
.container {
  background-color: #fff;
  min-height: 100vh;
}

/* Status bar */
.status-bar {
  display: flex;
  justify-content: space-between;
  padding: 10px 16px;
  font-size: 14px;
}

.status-icons {
  display: flex;
  gap: 6px;
}

/* Back button */
.back-button {
  padding: 16px;
  margin-top: 10px;
}

.back-icon {
  font-size: 28px;
  font-weight: bold;
}

/* Match header */
.match-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
}

.team {
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 30%;
}

.team-logo {
  width: 80px;
  height: 80px;
  margin-bottom: 10px;
}

.team-name {
  font-size: 20px;
  font-weight: bold;
  margin-bottom: 4px;
}

.team-status {
  font-size: 16px;
  color: #666;
}

.score-container {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.score {
  display: flex;
  align-items: center;
  font-size: 32px;
  font-weight: bold;
  color: #2c54b0;
}

.score-divider {
  margin: 0 10px;
}

.match-time {
  margin-top: 10px;
  font-size: 18px;
  font-weight: bold;
  color: #2c54b0;
  border-bottom: 2px solid #2c54b0;
  padding-bottom: 2px;
}

/* Match events */
.match-events {
  padding: 20px;
}

.event {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.event-team-left, .event-team-right {
  width: 45%;
  font-size: 16px;
}

.event-team-right {
  text-align: right;
}

.event-icon {
  width: 10%;
  text-align: center;
}

.red-card {
  width: 18px;
  height: 24px;
  background-color: red;
  margin: 0 auto;
}

/* Navigation tabs */
.tabs {
  display: flex;
  border-bottom: 1px solid #eee;
  margin-top: 20px;
}

.tab {
  flex: 1;
  padding: 16px 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  position: relative;
}

.tab-text {
  font-size: 16px;
  color: #999;
}

.active-text {
  color: #2c54b0;
  font-weight: bold;
}

.active-indicator {
  position: absolute;
  bottom: 0;
  width: 60%;
  height: 3px;
  background-color: #2c54b0;
}

/* Content tabs */
.content-tabs {
  display: flex;
  padding: 20px;
  gap: 10px;
}

.content-tab {
  padding: 12px 24px;
  background-color: #f5f5f5;
  border-radius: 20px;
}

.active-content-tab {
  background-color: #2c54b0;
}

.content-tab-text {
  font-size: 16px;
  color: #666;
}

.active-content-text {
  color: white;
  font-weight: bold;
}

/* Lineup section */
.lineup-container {
  padding: 20px;
}

.formation-header {
  display: flex;
  align-items: center;
  margin-bottom: 20px;
  background-color: #28a745;
  color: white;
  padding: 10px;
  border-top-left-radius: 10px;
  border-top-right-radius: 10px;
}

.small-logo {
  width: 30px;
  height: 30px;
  margin-right: 10px;
}

.formation-team {
  font-size: 18px;
  font-weight: bold;
  flex: 1;
}

.formation-structure {
  font-size: 18px;
  font-weight: bold;
}

.pitch {
  background-color: #28a745;
  border-bottom-left-radius: 10px;
  border-bottom-right-radius: 10px;
  padding: 20px;
  display: flex;
  flex-direction: column;
  position: relative;
  min-height: 500px;
}

.player-row {
  display: flex;
  justify-content: space-around;
  margin: 30px 0;
}

.player-position {
  display: flex;
  flex-direction: column;
  align-items: center;
  position: relative;
}

.player-circle {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background-color: #d32f2f;
  display: flex;
  justify-content: center;
  align-items: center;
  margin-bottom: 5px;
}

.player-number {
  color: white;
  font-weight: bold;
}

.player-name {
  color: white;
  font-size: 14px;
  text-align: center;
}

.card {
  position: absolute;
  top: -5px;
  right: -5px;
  width: 10px;
  height: 14px;
}

.yellow {
  background-color: yellow;
}

.red {
  background-color: red;
}

.goal-icon {
  position: absolute;
  top: -10px;
  left: -5px;
  font-size: 14px;
}

.captain-icon {
  position: absolute;
  bottom: 25px;
  right: -3px;
  font-size: 10px;
  color: white;
  background-color: rgba(0,0,0,0.3);
  width: 12px;
  height: 12px;
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
}

.gk {
  margin: 0 auto 40px auto;
}

.striker {
  margin: 40px auto 0 auto;
}

/* Field markings */
.pitch::before {
  content: '';
  position: absolute;
  top: 70%;
  left: 25%;
  right: 25%;
  height: 30%;
  border: 2px solid rgba(255,255,255,0.3);
  border-bottom: none;
  border-radius: 100px 100px 0 0;
}

.pitch::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 40%;
  right: 40%;
  height: 10px;
  background-color: white;
  border-radius: 5px;
}
</style>