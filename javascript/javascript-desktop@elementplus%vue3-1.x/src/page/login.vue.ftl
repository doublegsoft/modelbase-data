<template>
  <div class="min-h-screen bg-gray-50 flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md w-full space-y-8">
      <!-- Logo and Header -->
      <div class="text-center">
        <div class="flex items-center justify-center mb-8">
          <div class="bg-blue-600 rounded-lg p-2 mr-3">
            <svg class="w-6 h-6 text-white" fill="currentColor" viewBox="0 0 20 20">
              <path d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
            </svg>
          </div>
          <h1 class="text-xl font-semibold text-gray-900">Acme Co</h1>
        </div>
      </div>

      <!-- Login Form -->
      <div class="bg-white py-8 px-6 shadow-sm rounded-lg border border-gray-200">
        <div class="mb-6 text-center">
          <h2 class="text-2xl font-semibold text-gray-900 mb-2">Welcome back</h2>
          <p class="text-gray-600">Sign in to continue to your account.</p>
        </div>

        <form @submit.prevent="handleLogin" class="space-y-4">
          <!-- Username Field -->
          <div>
            <input
              v-model="form.username"
              type="text"
              placeholder="Username"
              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition-colors"
              required
            />
          </div>

          <!-- Password Field -->
          <div>
            <input
              v-model="form.password"
              type="password"
              placeholder="Password"
              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition-colors"
              required
            />
          </div>

          <!-- Forgot Password Link -->
          <div class="text-right">
            <a 
              href="#" 
              @click.prevent="handleForgotPassword"
              class="text-blue-600 hover:text-blue-700 text-sm font-medium"
            >
              Forgot Password?
            </a>
          </div>

          <!-- Login Button -->
          <button
            type="submit"
            :disabled="loading"
            class="w-full bg-blue-600 hover:bg-blue-700 disabled:bg-blue-400 text-white font-medium py-3 px-4 rounded-lg transition-colors focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
          >
            <span v-if="loading">Signing in...</span>
            <span v-else>Login</span>
          </button>
        </form>

        <!-- Divider -->
        <div class="mt-6">
          <div class="relative">
            <div class="absolute inset-0 flex items-center">
              <div class="w-full border-t border-gray-300"></div>
            </div>
            <div class="relative flex justify-center text-sm">
              <span class="px-2 bg-white text-gray-500">Or sign in with</span>
            </div>
          </div>
        </div>

        <!-- Social Login Buttons -->
        <div class="mt-6 grid grid-cols-2 gap-3">
          <button
            @click="handleSocialLogin('google')"
            class="w-full inline-flex justify-center items-center py-2.5 px-4 border border-gray-300 rounded-lg bg-white text-sm font-medium text-gray-700 hover:bg-gray-50 transition-colors"
          >
            <svg class="w-4 h-4 mr-2 text-red-500" viewBox="0 0 24 24">
              <path fill="currentColor" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
              <path fill="currentColor" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
              <path fill="currentColor" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
              <path fill="currentColor" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
            </svg>
            SearchEngineCo
          </button>

          <button
            @click="handleSocialLogin('facebook')"
            class="w-full inline-flex justify-center items-center py-2.5 px-4 border border-gray-300 rounded-lg bg-white text-sm font-medium text-gray-700 hover:bg-gray-50 transition-colors"
          >
            <svg class="w-4 h-4 mr-2 text-blue-600" fill="currentColor" viewBox="0 0 24 24">
              <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/>
            </svg>
            SocialMedia
          </button>
        </div>

        <!-- Sign Up Link -->
        <div class="mt-6 text-center">
          <span class="text-gray-600">Don't have an account? </span>
          <a 
            href="#" 
            @click.prevent="handleSignUp"
            class="text-blue-600 hover:text-blue-700 font-medium"
          >
            Sign up
          </a>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'

// Reactive form data
const form = reactive({
  username: '',
  password: ''
})

const loading = ref(false)

// Handle login form submission
const handleLogin = async () => {
  loading.value = true
  
  try {
    // Simulate API call
    console.log('Login attempt:', form)
    
    // Add your login logic here
    await new Promise(resolve => setTimeout(resolve, 1000))
    
    alert('Login successful!')
    
  } catch (error) {
    console.error('Login error:', error)
    alert('Login failed. Please try again.')
  } finally {
    loading.value = false
  }
}

// Handle forgot password
const handleForgotPassword = () => {
  console.log('Forgot password clicked')
  alert('Forgot password functionality would be implemented here')
}

// Handle social login
const handleSocialLogin = (provider) => {
  console.log(`Social login with `)
  alert(` login would be implemented here`)
}

// Handle sign up
const handleSignUp = () => {
  console.log('Sign up clicked')
  alert('Sign up page would be navigated to here')
}
</script>

<style scoped>
/* Additional custom styles if needed */
</style>