# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Rails 7.1 API-only application for managing continents and their associated images. Uses JWT authentication, PostgreSQL database, and JSONAPI serialization.

## Development Commands

### Setup
```bash
bundle install
rails db:create db:migrate
```

### Running the Server
```bash
rails server
# or
rails s
```

### Database Operations
```bash
rails db:migrate          # Run migrations
rails db:rollback         # Rollback last migration
rails db:reset            # Drop, create, and migrate database
rails db:seed             # Seed the database
```

### Testing
```bash
rails test                      # Run all tests
rails test test/models          # Run model tests
rails test test/controllers     # Run controller tests
rails test <file_path>          # Run specific test file
```

### Console
```bash
rails console
# or
rails c
```

## Architecture

### Authentication System

JWT-based authentication with Bearer token in Authorization header:
- **Token generation**: `POST /api/v1/tokens` with email/password returns JWT token
- **Token validation**: `Authenticable` concern in `app/controllers/concerns/authenticable.rb` provides `current_user` and `authenticate_user!` methods
- **Token service**: `JsonWebTokenService` in `app/service/json_web_token_service.rb` handles encode/decode
- **Secret key**: Stored in `ENV['JWT_SECRET_KEY']` (set in `.env` file)

Authorization header format: `Authorization: Bearer <token>`

### Data Model Hierarchy

```
User (has_secure_password, bcrypt)
  └── has_many :continents
        └── has_many :continent_images
```

Key relationships:
- Users can have multiple continents
- Continents belong to a user and can have multiple images
- Continents and continent_images have `is_public` boolean for visibility control

### API Structure

All endpoints are namespaced under `/api/v1/`:
- `POST /api/v1/tokens` - Authentication (public)
- `/api/v1/users` - User management
- `/api/v1/continents` - Continent CRUD (index/show are public for public continents, create/update/destroy require auth)
- `/api/v1/continent_images` - Image management

### Visibility Logic

Continents controller implements visibility rules:
- Authenticated users see: their own continents + all public continents
- Unauthenticated users see: only public continents
- Implementation in `app/controllers/api/v1/continents_controller.rb:6-11`

### Serialization

Uses `jsonapi-serializer` gem with dedicated serializers in `app/serializers/`:
- All serializers include `JSONAPI::Serializer`
- Helper method `serialized(resource, serializer)` in `ResponseSerializer` concern
- ApplicationController includes `ResponseSerializer` for all controllers

### Controller Concerns

Two key concerns included in ApplicationController:
1. **Authenticable** - JWT authentication (current_user, authenticate_user!)
2. **ResponseSerializer** - JSON API serialization helper

## Key Files

- `config/routes.rb` - API routes definition
- `app/controllers/concerns/authenticable.rb` - Authentication logic
- `app/service/json_web_token_service.rb` - JWT token handling
- `db/schema.rb` - Database schema reference
- `.env` - Environment variables (JWT_SECRET_KEY required)

## Database

PostgreSQL database with Active Storage configured for file attachments.
