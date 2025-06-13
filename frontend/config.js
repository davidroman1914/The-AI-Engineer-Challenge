// Configuration file for Skynet Chat
const config = {
    API_KEY: process.env.OPENAI_API_KEY || '', // Will be populated from environment variable
    API_URL: 'http://localhost:8000/api/chat'
};

// Export the configuration
export default config; 