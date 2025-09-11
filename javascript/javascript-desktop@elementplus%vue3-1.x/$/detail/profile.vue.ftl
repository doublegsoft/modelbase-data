<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Header Navigation -->
    <header class="bg-white border-b border-gray-200 sticky top-0 z-50">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
          <!-- Logo -->
          <div class="flex items-center">
            <div class="flex-shrink-0 flex items-center">
              <span class="text-blue-600 font-bold text-xl">🔗 ConnectU</span>
            </div>
          </div>

          <!-- Navigation Menu -->
          <nav class="hidden md:flex space-x-8">
            <a href="#" class="text-gray-900 hover:text-blue-600 px-3 py-2 text-sm font-medium">Home</a>
            <a href="#" class="text-gray-900 hover:text-blue-600 px-3 py-2 text-sm font-medium">Network</a>
            <a href="#" class="text-gray-900 hover:text-blue-600 px-3 py-2 text-sm font-medium">Jobs</a>
            <a href="#" class="text-gray-900 hover:text-blue-600 px-3 py-2 text-sm font-medium">Messages</a>
            <a href="#" class="text-gray-900 hover:text-blue-600 px-3 py-2 text-sm font-medium">Notifications</a>
          </nav>

          <!-- Profile Avatar -->
          <div class="flex items-center">
            <div class="w-8 h-8 bg-orange-300 rounded-full flex items-center justify-center">
              <span class="text-white text-sm font-medium">👤</span>
            </div>
          </div>
        </div>
      </div>
    </header>

    <!-- Main Content -->
    <main class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <!-- Profile Header -->
      <div class="bg-white rounded-lg shadow-sm border border-gray-200 mb-6">
        <div class="px-6 py-8">
          <!-- Profile Image and Basic Info -->
          <div class="flex flex-col items-center text-center mb-6">
            <div class="w-32 h-32 bg-orange-200 rounded-full mb-4 flex items-center justify-center overflow-hidden">
              <div class="w-full h-full bg-gradient-to-b from-orange-200 to-orange-300 rounded-full flex items-center justify-center">
                <span class="text-4xl">👩🏻‍💼</span>
              </div>
            </div>
            <h1 class="text-3xl font-bold text-gray-900 mb-2">{{ profile.name }}</h1>
            <p class="text-lg text-gray-600 mb-2">{{ profile.title }}</p>
            <p class="text-gray-500">{{ profile.location }}</p>
          </div>

          <!-- Follow Button -->
          <div class="flex justify-center">
            <button 
              @click="toggleFollow"
              class="px-6 py-2 border border-blue-600 text-blue-600 hover:bg-blue-50 rounded-full font-medium transition-colors"
            >
              {{ isFollowing ? 'Following' : 'Follow' }}
            </button>
          </div>
        </div>

        <!-- Navigation Tabs -->
        <div class="border-t border-gray-200">
          <nav class="flex space-x-8 px-6">
            <button
              v-for="tab in tabs"
              :key="tab.id"
              @click="activeTab = tab.id"
              :class="[
                'py-4 px-1 border-b-2 font-medium text-sm transition-colors',
                activeTab === tab.id
                  ? 'border-blue-500 text-blue-600'
                  : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
              ]"
            >
              {{ tab.name }}
            </button>
          </nav>
        </div>
      </div>

      <!-- Tab Content -->
      <div class="bg-white rounded-lg shadow-sm border border-gray-200">
        <div class="p-6">
          <!-- About Tab -->
          <div v-if="activeTab === 'about'">
            <h2 class="text-2xl font-bold text-gray-900 mb-6">About</h2>
            
            <div class="space-y-6">
              <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                  <h3 class="text-sm font-medium text-gray-500 mb-1">Location</h3>
                  <p class="text-gray-900">{{ profile.location }}</p>
                </div>
                <div>
                  <h3 class="text-sm font-medium text-gray-500 mb-1">Industry</h3>
                  <p class="text-gray-900">{{ profile.industry }}</p>
                </div>
                <div>
                  <h3 class="text-sm font-medium text-gray-500 mb-1">Experience</h3>
                  <p class="text-gray-900">{{ profile.experience }}</p>
                </div>
                <div>
                  <h3 class="text-sm font-medium text-gray-500 mb-1">Skills</h3>
                  <p class="text-gray-900">{{ profile.skills.join(', ') }}</p>
                </div>
              </div>
            </div>

            <!-- Experience Section -->
            <div class="mt-8">
              <h2 class="text-2xl font-bold text-gray-900 mb-6">Experience</h2>
              <div class="space-y-4">
                <div v-for="job in profile.jobs" :key="job.id" class="border-l-2 border-gray-200 pl-4">
                  <h3 class="text-lg font-semibold text-gray-900">{{ job.title }}</h3>
                  <p class="text-gray-600 mb-1">{{ job.period }}</p>
                  <p class="text-gray-500">{{ job.company }}</p>
                </div>
              </div>
            </div>

            <!-- Skills Section -->
            <div class="mt-8">
              <h2 class="text-2xl font-bold text-gray-900 mb-6">Skills</h2>
              <div class="flex flex-wrap gap-2">
                <span 
                  v-for="skill in profile.skillsDetailed" 
                  :key="skill"
                  class="px-3 py-1 bg-gray-100 text-gray-700 rounded-full text-sm"
                >
                  {{ skill }}
                </span>
              </div>
            </div>

            <!-- Education Section -->
            <div class="mt-8">
              <h2 class="text-2xl font-bold text-gray-900 mb-6">Education</h2>
              <div class="space-y-4">
                <div v-for="edu in profile.education" :key="edu.id" class="border-l-2 border-gray-200 pl-4">
                  <h3 class="text-lg font-semibold text-gray-900">{{ edu.degree }}</h3>
                  <p class="text-gray-600 mb-1">{{ edu.period }}</p>
                  <p class="text-gray-500">{{ edu.school }}</p>
                </div>
              </div>
            </div>
          </div>

          <!-- Posts Tab -->
          <div v-else-if="activeTab === 'posts'">
            <h2 class="text-2xl font-bold text-gray-900 mb-6">Posts</h2>
            <div class="text-center py-12">
              <p class="text-gray-500">No posts to show</p>
            </div>
          </div>

          <!-- Articles Tab -->
          <div v-else-if="activeTab === 'articles'">
            <h2 class="text-2xl font-bold text-gray-900 mb-6">Articles</h2>
            <div class="text-center py-12">
              <p class="text-gray-500">No articles to show</p>
            </div>
          </div>

          <!-- Activity Tab -->
          <div v-else-if="activeTab === 'activity'">
            <h2 class="text-2xl font-bold text-gray-900 mb-6">Activity</h2>
            <div class="text-center py-12">
              <p class="text-gray-500">No recent activity</p>
            </div>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'

// Reactive data
const activeTab = ref('about')
const isFollowing = ref(false)

const tabs = [
  { id: 'about', name: 'About' },
  { id: 'posts', name: 'Posts' },
  { id: 'articles', name: 'Articles' },
  { id: 'activity', name: 'Activity' }
]

const profile = reactive({
  name: 'Sophia Bennett',
  title: 'Product Designer at Tech Innovators Inc. | Passionate about creating user-centric designs',
  location: 'San Francisco Bay Area',
  industry: 'Technology',
  experience: '5 years',
  skills: ['UI/UX Design', 'User Research', 'Prototyping'],
  skillsDetailed: ['UI/UX Design', 'User Research', 'Prototyping', 'Interaction Design', 'Wireframing'],
  jobs: [
    {
      id: 1,
      title: 'Product Designer',
      period: '2019 - Present',
      company: 'Tech Innovators Inc.'
    }
  ],
  education: [
    {
      id: 1,
      degree: 'Bachelor of Science in Design',
      period: '2015 - 2019',
      school: 'University of California, Berkeley'
    }
  ]
})

// Methods
const toggleFollow = () => {
  isFollowing.value = !isFollowing.value
}
</script>

<style scoped>
/* Additional custom styles if needed */
.transition-colors {
  transition: color 0.2s ease-in-out, background-color 0.2s ease-in-out, border-color 0.2s ease-in-out;
}
</style>