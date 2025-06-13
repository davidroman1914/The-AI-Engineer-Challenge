.PHONY: start stop start-frontend start-backend stop-frontend stop-backend

# Start both frontend and backend servers
start: start-frontend start-backend

# Stop both frontend and backend servers
stop: stop-frontend stop-backend

# Start the frontend server
start-frontend:
	@echo "Starting frontend server..."
	@cd frontend && python3 -m http.server 3000 & echo $$! > .frontend.pid

# Start the backend server
start-backend:
	@echo "Starting backend server..."
	@cd api && export PATH="$$HOME/Library/Python/3.9/bin:$$PATH" && PYTHONPATH=$$PWD python3 -m uvicorn app:app --reload & echo $$! > .backend.pid

# Stop the frontend server
stop-frontend:
	@echo "Stopping frontend server..."
	@pkill -f "python3 -m http.server 3000" || true
	@lsof -ti:3000 | xargs kill -9 2>/dev/null || true
	@rm -f frontend/.frontend.pid

# Stop the backend server
stop-backend:
	@echo "Stopping backend server..."
	@pkill -f "uvicorn app:app" || true
	@lsof -ti:8000 | xargs kill -9 2>/dev/null || true
	@rm -f api/.backend.pid

# Clean up any leftover PID files
clean:
	@rm -f frontend/.frontend.pid api/.backend.pid 