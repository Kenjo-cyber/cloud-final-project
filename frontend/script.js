// Get references to HTML elements
const addBtn = document.getElementById('add-btn');
const taskInput = document.getElementById('task-input');
const taskList = document.getElementById('task-list');

// Load tasks from backend on page load
window.addEventListener('DOMContentLoaded', async () => {
  try {
    const response = await fetch('http://127.0.0.1:5000/tasks');
    const data = await response.json();
    data.tasks.forEach(task => addTaskToList(task.text));
  } catch (error) {
    console.error('Error loading tasks:', error);
  }
});

// Add task on button click or Enter key
addBtn.addEventListener('click', addTask);
taskInput.addEventListener('keypress', function(e) {
  if (e.key === 'Enter') addTask();
});

// Function to add a new task
async function addTask() {
  const taskText = taskInput.value.trim();
  if (taskText === '') return;

  try {
    // Send task to backend
    const response = await fetch('http://127.0.0.1:5000/tasks', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ text: taskText })
    });

    const data = await response.json();
    addTaskToList(data.task); // Add to DOM
    taskInput.value = '';
  } catch (error) {
    console.error('Error adding task:', error);
  }
}

// Function to update the DOM
function addTaskToList(taskText) {
  const li = document.createElement('li');
  li.textContent = taskText;

  // Toggle completion
  li.addEventListener('click', () => {
    li.classList.toggle('completed');
  });

  // Delete button
  const deleteBtn = document.createElement('button');
  deleteBtn.textContent = '❌';
  deleteBtn.addEventListener('click', () => {
    taskList.removeChild(li);
    // Optional: send DELETE request to backend here
  });

  li.appendChild(deleteBtn);
  taskList.appendChild(li);
}