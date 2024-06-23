```markdown
# Task Management Web Application

## Introduction
This project is a Task Management web application built with Ruby on Rails, using PostgreSQL as the database. Users can authenticate themselves to create, update, and manage tasks. Tasks have three states: Backlog, In-progress, and Done. The application also sends email alerts 1 day and 1 hour before the task's deadline if the task is not marked as done.

## Features

- User authentication for creating and managing tasks.
- Tasks have three states (Backlog, In-progress, Done) and deadlines.
- Email alerts for upcoming deadlines.
- Integration with Google Calendar API.
- Responsive UI with a good design.

## Prerequisites

- Ruby (3.0.7)
- Rails (7.0.8.4)
- PostgreSQL
- Node.js and Yarn
- Redis (for background job processing)

## Setup Instructions

### 1. Clone the Repository
```sh
git clone <repository_url>
cd task_management_app
```

### 2. Install Dependencies
```sh
bundle install
yarn install --check-files
```

### 3. Setup Database
```sh
rails db:create
rails db:migrate
rails db:seed
```

### 4. Setup Environment Variables
Create a `.env` file in the root directory with the following variables:
```
DATABASE_USERNAME=your_database_username
DATABASE_PASSWORD=your_database_password
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret
```

### 5. Start the Server
```sh
rails server
```

### 6. Start Redis (For background jobs)
```sh
redis-server
```

### 7. Start Sidekiq (Background Job Processor)
```sh
bundle exec sidekiq
```

## Code Structure

### Models
- **User**: 
  - Manages user authentication.
  - Fields: `email`, `password_digest`, etc.
- **Task**: 
  - Manages tasks' attributes and states.
  - Fields: `title`, `description`, `state`, `deadline`, `user_id`.

### Controllers
- **TasksController**: 
  - Handles CRUD operations for tasks.
  - Actions: `index`, `new`, `create`, `edit`, `update`, `destroy`.
- **SessionsController**: 
  - Manages user sessions for login and logout.
  - Actions: `new`, `create`, `destroy`.

### Views
- **Tasks**: 
  - Contains views for listing (`index.html.erb`), creating (`new.html.erb`), editing (`edit.html.erb`), and showing (`show.html.erb`) tasks.
- **Layouts**: 
  - Application layout with shared partials like header, footer.

### Background Jobs
- **TaskDeadlineReminderJob**: 
  - Sends email reminders 1 day and 1 hour before the deadline.
  - Utilizes Sidekiq for job scheduling.

### Services
- **GoogleCalendarService**: 
  - Integrates Google Calendar API for event synchronization.
  - Methods: `create_event(task)`, `update_event(task)`, `delete_event(task)`.

### Mailers
- **TaskMailer**: 
  - Handles sending email reminders.
  - Methods: `deadline_reminder_email(user, task)`.

### Routes
Defines routes for tasks and user sessions.
- Example routes:
```ruby
resources :tasks
resource :session, only: [:new, :create, :destroy]
```

### Configuration
- **Database**: Configured in `config/database.yml`.
- **Environment Variables**: Managed using the `dotenv-rails` gem.
- **Sidekiq**: Configuration for background job processing.

## Tests
Tests are written using RSpec.
- Test files located in `spec/` directory.
- Includes models, controllers, and services tests.

### Run Tests
```sh
bundle exec rspec
```

## Bonus: Google Calendar Integration
Google Calendar integration is handled by `GoogleCalendarService`. It synchronizes tasks with Google Calendar events upon creation, update, and deletion.

## Conclusion
This Task Management application provides a robust solution for managing tasks with deadlines and integrating external services like Google Calendar. The codebase is structured to ensure maintainability and scalability.

---

Feel free to explore and contribute to enhance this project further!
```

This README file explains the setup instructions, features, and code structure of the Task Management web application.