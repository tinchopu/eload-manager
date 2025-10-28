# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a lightweight Go REST service that calculates when an electric vehicle battery (specifically a Nissan Leaf with 62 KW battery) will reach 80% charge. The service uses the Gin web framework and runs as a containerized application.

**Core functionality**: Given the current battery percentage, calculate the time when charging will complete at 80% using a fixed charging rate of 3.73 KW (16A).

## Development Commands

### Building and Running Locally
```bash
# Build the application
go build -o main main.go

# Run the application (listens on port 8080)
./main

# Run with go run
go run main.go
```

### Docker
```bash
# Build Docker image
docker build -t eload-manager .

# Run container
docker run -p 8080:8080 eload-manager
```

### Testing the API
```bash
# Test endpoint (replace 45 with current battery percentage)
curl http://localhost:8080/complete/45
```

## Architecture

### Single-File Application
The entire application logic resides in `main.go` with:
- **Framework**: Gin web framework in release mode
- **Single endpoint**: `GET /complete/:currentPercentage`
- **Response**: String containing completion time in format "2.1.2006 15:04" (Europe/Berlin timezone)

### Calculation Logic
Constants defined in `main.go:23-25`:
- `batteryCapacity`: 62 KW (Nissan Leaf battery size)
- `maxload`: 3.73 KW (charging rate at 16A)
- `targetedLoad`: 80% (target charge level)

Formula: `timeToComplete = (remainingKW / chargingRate) + currentTime`

### Deployment
- Multi-stage Docker build using Go 1.23 and distroless base image
- Runs as non-root user (`scratchuser`)
- GitHub Actions workflow deploys to Docker Hub on tag push (`refs/tags/*`)
- Images tagged as `apuetz/eload-manager:latest` and `apuetz/eload-manager:<version>`

## Project Structure
This is a single-file Go application with no subdirectories or complex module structure. All business logic is in `main.go`.
