## App Plan: To-Do List

- Frontend: HTML/CSS + JS 
- Backend: Python Flask
- Database: PostgreSQL

### Features: # The futures of the To-Do List
- Add a task
- View all tasks
- Mark task as complete
- Delete a task

### API Endpoints
- POST /tasks → Add a task
- GET /tasks → Get all tasks
- PUT /tasks/:id → Mark as complete
- DELETE /tasks/:id → Delete a task

### Database Schema
- Table: tasks
  - id (int, primary key)
  - title (text)
  - completed (boolean)
  - created_at (timestamp)

### Repo structure
cloud-final-project/
├── backend/
│   └── app.py, Dockerfile
├── infra/
│   └── *.tf files
├── .github/
│   └── workflows/deploy.yml
└── README.md