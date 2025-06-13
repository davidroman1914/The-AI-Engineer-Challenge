.PHONY: start stop clean frontend backend kill-ports

# Default target
all: start

# Kill any processes using our ports
kill-ports:
	@echo "Killing processes on ports 3000 and 8000..."
	@lsof -ti:3000 | xargs kill -9 2>/dev/null || true
	@lsof -ti:8000 | xargs kill -9 2>/dev/null || true

# Start both servers
start: kill-ports frontend backend

# Start the frontend server
frontend:
	@echo "Starting frontend server..."
	@cd frontend && python3 -m http.server 3000 & echo $$! > .frontend.pid

# Start the backend server
backend:
	@echo "Starting backend server..."
	@cd api && export PATH="$$HOME/Library/Python/3.9/bin:$$PATH" && python3 -m uvicorn app:app --reload --port 8000 & echo $$! > .backend.pid

# Stop all servers
stop: kill-ports
	@echo "Stopping servers..."
	@if [ -f .frontend.pid ]; then kill $$(cat .frontend.pid) 2>/dev/null || true; rm .frontend.pid; fi
	@if [ -f .backend.pid ]; then kill $$(cat .backend.pid) 2>/dev/null || true; rm .backend.pid; fi

# Clean up
clean: stop
	@echo "Cleaning up..."
	@rm -f .frontend.pid .backend.pid

# Help target
help:
	@echo "Available targets:"
	@echo "  make start      - Start both frontend and backend servers"
	@echo "  make stop       - Stop all running servers"
	@echo "  make clean      - Stop servers and clean up PID files"
	@echo "  make frontend   - Start only the frontend server"
	@echo "  make backend    - Start only the backend server"
	@echo "  make kill-ports - Kill any processes using ports 3000 and 8000" 