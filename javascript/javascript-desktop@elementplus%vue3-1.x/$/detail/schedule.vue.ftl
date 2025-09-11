<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Header -->
    <header class="bg-white border-b border-gray-200">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between h-16">
          <div class="flex items-center space-x-8">
            <div class="flex items-center space-x-2">
              <div class="w-6 h-6 bg-black rounded-sm flex items-center justify-center">
                <div class="w-3 h-3 bg-white rounded-sm"></div>
              </div>
              <span class="text-xl font-semibold text-gray-900">Eventide</span>
            </div>
            <nav class="hidden md:flex space-x-8">
              <a href="#" class="text-gray-600 hover:text-gray-900 transition-colors">Dashboard</a>
              <a href="#" class="text-gray-900 font-medium">Calendar</a>
              <a href="#" class="text-gray-600 hover:text-gray-900 transition-colors">Contacts</a>
              <a href="#" class="text-gray-600 hover:text-gray-900 transition-colors">Resources</a>
            </nav>
          </div>
          <div class="flex items-center space-x-4">
            <button class="p-2 text-gray-600 hover:text-gray-900 transition-colors">
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-5 5v-5z"/>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 7h6m0 10v-3m-3 3h.01M9 17h.01M9 14h.01M12 14h.01M15 11h.01M12 11h.01M9 11h.01M7 21h10a2 2 0 002-2V5a2 2 0 00-2-2H7a2 2 0 00-2 2v14a2 2 0 002 2z"/>
              </svg>
            </button>
            <div class="w-8 h-8 rounded-full overflow-hidden">
              <img 
                src="https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=100&q=80" 
                alt="Profile" 
                class="w-full h-full object-cover"
              />
            </div>
          </div>
        </div>
      </div>
    </header>

    <!-- Main Content -->
    <main class="max-w-4xl mx-auto py-8 px-4 sm:px-6 lg:px-8">
      <!-- Breadcrumb -->
      <nav class="mb-8">
        <div class="flex items-center text-sm text-gray-500 space-x-2">
          <a href="#" class="hover:text-gray-700 transition-colors">Calendar</a>
          <span>/</span>
          <span class="text-gray-900">Meeting with Alex</span>
        </div>
      </nav>

      <!-- Meeting Header -->
      <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-900 mb-2">
          {{ meeting.title }}
        </h1>
        <p class="text-gray-600">
          {{ meeting.description }}
        </p>
      </div>

      <!-- Details Section -->
      <section class="mb-8">
        <h2 class="text-xl font-semibold text-gray-900 mb-6">Details</h2>
        <div class="bg-white rounded-lg border border-gray-200 overflow-hidden">
          <div class="divide-y divide-gray-200">
            <div class="px-6 py-4 flex items-center justify-between">
              <span class="text-gray-600 font-medium">Date & Time</span>
              <span class="text-gray-900">{{ meeting.dateTime }}</span>
            </div>
            <div class="px-6 py-4 flex items-center justify-between">
              <span class="text-gray-600 font-medium">Location</span>
              <span class="text-gray-900">{{ meeting.location }}</span>
            </div>
            <div class="px-6 py-4 flex items-center justify-between">
              <span class="text-gray-600 font-medium">Participants</span>
              <span class="text-gray-900">{{ meeting.participants.join(', ') }}</span>
            </div>
          </div>
        </div>
      </section>

      <!-- Resources Section -->
      <section class="mb-8">
        <h2 class="text-xl font-semibold text-gray-900 mb-6">Resources</h2>
        <div class="bg-white rounded-lg border border-gray-200">
          <div class="px-6 py-4">
            <div 
              v-for="resource in meeting.resources" 
              :key="resource.id"
              class="flex items-center space-x-3 py-2"
            >
              <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
              </svg>
              <span class="text-gray-900 hover:text-blue-600 cursor-pointer transition-colors">
                {{ resource.name }}
              </span>
            </div>
          </div>
        </div>
      </section>

      <!-- Notes Section -->
      <section class="mb-8">
        <h2 class="text-xl font-semibold text-gray-900 mb-6">Notes</h2>
        <div class="bg-white rounded-lg border border-gray-200 px-6 py-4">
          <p class="text-gray-700 leading-relaxed">
            {{ meeting.notes }}
          </p>
        </div>
      </section>

      <!-- Attachments Section -->
      <section class="mb-8">
        <h2 class="text-xl font-semibold text-gray-900 mb-6">Attachments</h2>
        <div class="bg-white rounded-lg border border-gray-200">
          <div class="px-6 py-4">
            <div 
              v-for="attachment in meeting.attachments" 
              :key="attachment.id"
              class="flex items-center space-x-3 py-2"
            >
              <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
              </svg>
              <span class="text-gray-900 hover:text-blue-600 cursor-pointer transition-colors">
                {{ attachment.name }}
              </span>
            </div>
          </div>
        </div>
      </section>

      <!-- Edit Button -->
      <div class="flex justify-end">
        <button 
          @click="editMeeting"
          class="px-6 py-2 bg-gray-900 text-white rounded-lg hover:bg-gray-800 transition-colors font-medium"
        >
          Edit
        </button>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref } from 'vue'

// Meeting data
const meeting = ref({
  title: 'Meeting with Alex',
  description: 'Discuss project updates and next steps',
  dateTime: 'Tuesday, July 23, 2024, 2:00 PM - 3:00 PM',
  location: 'Conference Room A',
  participants: ['Alex', 'Sarah', 'David'],
  resources: [
    {
      id: 1,
      name: 'Project Proposal'
    }
  ],
  notes: 'Key discussion points: Project timeline, resource allocation, and upcoming milestones. Please review the attached proposal before the meeting.',
  attachments: [
    {
      id: 1,
      name: 'Project Proposal.pdf'
    }
  ]
})

// Methods
const editMeeting = () => {
  console.log('Edit meeting clicked')
  // Handle edit functionality
}

// You could also add methods for handling resource/attachment clicks
const openResource = (resource) => {
  console.log('Opening resource:', resource.name)
  // Handle resource opening
}

const downloadAttachment = (attachment) => {
  console.log('Downloading attachment:', attachment.name)
  // Handle attachment download
}
</script>

<style scoped>
/* Custom styles if needed */
</style>